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
    def list
      
    end

    summary 'Add SSH key to the user account'
    syntax ""
    argument :key, 'SSH public key filepath', ["-k", "--ssh key-filepath"]
    def add
      
    end

    summary 'Update SSH key for the user account'
    syntax ''
    def update
      raise
    end

    summary 'Remove SSH key from the user account'
    alias_action :delete
    def remove
      
    end

  end
end