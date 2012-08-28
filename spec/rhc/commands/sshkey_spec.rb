require 'spec_helper'
require 'rhc/commands/sshkey'
require 'rhc/config'


describe RHC::Commands::SshKey do
  before(:each) do
    RHC::Config.set_defaults
  end
  
  describe 'list' do
      
    context "when run with list command" do
      
      let(:arguments) { %w[sshkey list --noprompt --config test.conf -l test@test.foo -p  password --trace] }

      before(:each) do
        @rc = MockRestClient.new
      end

      it { expect { run }.should exit_with_code(0) }
      it { run_output.should match("Name: mockkey") }
    end
  end
  
  describe "add" do
    context "when adding a valid key" do
      let(:arguments) { %w[add -l test@test.foo -p password id_dsa.pub] }
    
      before :each do
        @rc = MockRestClient.new
      end
    end
  end
  
  describe "remove" do
    context "when removing an existing key" do
      let (:arguments) { %w[sshkey remove --noprompt --config test.conf -l test@test.foo -p password mockkey2] }
      
      before :each do
        @rc = MockRestClient.new
        @keys = @rc.find_all_keys
      end
      
      it 'deletes the key' do
        num_keys = @keys.length
        expect {run}.should exit_with_code(0)
        @rc.find_all_keys.length.should == num_keys - 1
      end
    end

    context "when removing a nonexistent key" do
      let (:arguments) { %w[sshkey remove --noprompt --config test.conf -l test@test.foo -p password no_match] }
      
      before :each do
        @rc = MockRestClient.new
        @keys = @rc.find_all_keys
      end
      
      it 'leaves keys untouched' do
        num_keys = @keys.length
        expect {run}.should exit_with_code(0)
        @rc.find_all_keys.length.should == num_keys
      end
    end
  end
  
  describe "update" do
    context "when invoked" do
      let (:arguments) { %w[sshkey update] }
      
      # RHC::Commands::SshKey#update throws RuntimeError, but it is swallowed
      # up by the wrapper, so we only see status code 1.
      it "exits with status code 1" do
        expect {run}.should exit_with_code(1)
      end
    end
  end
end