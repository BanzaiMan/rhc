require 'spec_helper'
require 'rhc/commands/sshkey'
require 'rhc/config'


describe RHC::Commands::SshKey do
  before(:each) do
    RHC::Config.set_defaults
  end
  
  describe 'list' do
      
    context "when run with list command" do
      
      let(:arguments) { ['sshkey', 'list', '--noprompt', '--config', 'test.conf', '-l', 'test@test.foo', '-p',  'password', '--trace'] }

      before(:each) do
        @rc = MockRestClient.new
      end

      it { expect { run }.should exit_with_code(0) }
      it { run_output.should match("Name: mockkey") }
    end
  end
end