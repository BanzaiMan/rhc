#! /usr/bin/env ruby

require 'rhc/coverage_helper'
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
  
      puts ""
      puts "SSH keys"
      puts "========"

      # first list the primary key
      puts "       Name: default"
      puts "       Type: #{ssh_keys['ssh_type']}"
      puts "Fingerprint: #{ssh_keys['fingerprint']}"
      #puts "        Key: #{ssh_keys['ssh_key']}"
      puts ""
    
      # now list the additional keys
      if additional_ssh_keys && additional_ssh_keys.kind_of?(Hash)
        additional_ssh_keys.each do |name, keyval|
          puts "       Name: #{name}"
          puts "       Type: #{keyval['type']}"
          puts "Fingerprint: #{keyval['fingerprint']}"
          #puts "        Key: #{keyval['key']}"
          puts ""
        end
      end
    end

    summary 'Add SSH key to the user account'
    syntax ""
    argument :key, 'SSH public key filepath', ["-k", "--ssh key-filepath"]
    option ["--timeout timeout"], "Timeout, in seconds, for the session"
    def add
      add_or_update_key 'add', options.identifier, options.ssh, options.rhlogin, options.password
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

  end
end