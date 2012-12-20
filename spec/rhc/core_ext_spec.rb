require 'spec_helper'
require 'rhc/helpers'

describe Hash do
  describe '#deep_cleanse' do
    HIDDEN = RHC::CoreExt::PASSWORD_MASK
    before :each do
      @clean = {:foo => 'foo', :bar => 'bar'}
      @has_passwd = {:password => 'supersecret', :not_password => 'publicinfo'}
      @passwd_nested = {:password => 'supersecret', :deep => {:password => 'doubleagent', :foo => 'bar'}}
      @passwd_nested_in_array = {:password => 'supersecret', :deep => [{:password => 'doubleagent', :foo => 'bar'}]}
    end
    it 'leaves data unchanged if no key matches the arg' do
      @clean.deep_cleanse('password').should == @clean
    end
    
    it 'hides the value if the key matches the arg' do
      @has_passwd.deep_cleanse('password').should == {:password => HIDDEN, :not_password => 'publicinfo'}
    end
    
    it 'hides the value in nested structures' do
      @passwd_nested.deep_cleanse('password').should ==
        {:password => HIDDEN, :deep => {:password => HIDDEN, :foo => 'bar'}}
      @passwd_nested_in_array.deep_cleanse('password').should ==
        {:password => HIDDEN, :deep => [{:password => HIDDEN, :foo => 'bar'}]}
    end
  end
end