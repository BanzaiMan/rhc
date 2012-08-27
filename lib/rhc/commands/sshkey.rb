#! /usr/bin/env ruby

require 'rhc/commands/base'

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
      ssh_keys = rest_client.find_all_keys
      ssh_keys.each do |key|
        puts key.format(ERB.new <<-FORMAT)
       Name: <%= name %>
       Type: <%= type %>
Fingerprint: <%= Net::SSH::KeyFactory.load_data_public_key(
            "#{key.type} #{key.content}").fingerprint %>

        FORMAT
      end
      # each user should have at least one SSH key, so we should not have to 
      # worry about 'ssh_keys' being empty, but you'd never know
      !ssh_keys.empty? 
    end

    summary 'Add SSH key to the user account'
    syntax ""
    argument :key, 'SSH public key filepath', ["-k", "--ssh key-filepath"]
    option ["--timeout timeout"], "Timeout, in seconds, for the session"
    option ['-i', '--identifier name'], 'Identifier for this key'
    def add(key)
      type, content, comment = File.open(key).gets.chomp.split
      rest_client.add_key(options.identifier, content, type)
      0
    end

    summary 'Update SSH key for the user account'
    syntax ''
    def update
      raise
    end

    summary 'Remove SSH key from the user account'
    alias_action :delete
    argument :name, 'SSH key to remove', ['-k']
    option ["--timeout timeout"], "Timeout, in seconds, for the session"
    def remove(name)
      rest_client.delete_key(name)
      say "SSH key '#{name}' has been removed"
      0
    end
    
  end
end