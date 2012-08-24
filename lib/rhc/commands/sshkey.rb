#! /usr/bin/env ruby

require 'rhc/coverage_helper'
require 'rhc/commands/base'
require 'rhc/config'
require 'rhc/vendor/sshkey'

module RHC::Commands
  class SshKey < Base
    summary 'Manage multiple keys for the registered rhcloud user.'
    syntax '<action>'
    default_action :list
    
    summary 'Display all the SSH keys for the user account'
    syntax ''
    alias_action :show
    option ["--timeout timeout"], "Timeout, in seconds, for the session"
    def list
      ssh_keys = RHC::get_ssh_keys(RHC::Config[libra_server], options.rhlogin, options.password, RHC::Config[default_proxy])
      additional_ssh_keys = ssh_keys['keys']
      
      keys = []
      # top-level key will be named 'default'
      keys << SSHPublicKey.new(ssh_keys)
      additional_ssh_keys.each do |k, v|
        keys << SSHPublicKey.new('name' => k, 'ssh_type' => v['type'], 'fingerprint' => v['fingerprint'])
      end

      puts "\nSSH keys\n========"
      puts keys.map {|k| k.to_s}
      
      true
    end

    summary 'Add SSH key to the user account'
    syntax ""
    argument :key, 'SSH public key filepath', ["-k", "--ssh key-filepath"]
    option ["--timeout timeout"], "Timeout, in seconds, for the session"
    option ['-i', '--identifier name'], 'Identifier for this key'
    def add(key)
      add_or_update_key 'add', options.identifier, key, options.rhlogin, options.password
    end

    summary 'Update SSH key for the user account'
    syntax ''
    def update
      raise
    end

    summary 'Remove SSH key from the user account'
    alias_action :delete
    option ["--timeout timeout"], "Timeout, in seconds, for the session"
    def remove
      data = {:rhlogin => options.rhlogin, :key_name => options.identifier, :action => 'remove-key'}
      handle_key_mgmt_response URI.parse("https://#{RHC::Config[libra_server]}/broker/ssh_keys"), data, options.password      
    end
    
    private
    ## given a hash with keys 'name', 'ssh_type' and 'fingerprint', treat it
    ## as though it is a representation of an SSH public key.
    ## We can't use RHC::Vendor::SSHKey here, since that requires access to
    ## a private key, which we don't have
    class SSHPublicKey
      attr_reader :name, :type, :finger_print
      def initialize(data)
        @name = data['name'] || 'default'
        @type = data['ssh_type']
        @finger_print = data['fingerprint']
      end
      
      def to_s
        puts "       Name: #{name}"
        puts "       Type: #{type}"
        puts "Fingerprint: #{finger_print}"
        puts ""
      end
    end

  end
end