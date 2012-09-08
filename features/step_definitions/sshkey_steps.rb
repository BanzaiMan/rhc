include RHCHelper

Before do
  SshKey.remove "key1"
  SshKey.remove "key2"
end

When /^'rhc sshkey (\S+)( .*?)?'(?: command)? is run$/ do |subcommand, rest|
  if subcommand =~ /^(list|show|add|remove|delete|update)$/
    SshKey.send subcommand.to_sym, rest
    @sshkey_output = SshKey.sshkey_output
    @exitcode      = SshKey.exitcode
  end
end

Given /^the SSH key "(.*?)" does not exist$/ do |key|
  SshKey.remove "key"
end

# add key d
Given /^the SSH key "(.*?)" already exists$/ do |key|
  keyfile = File.join(File.dirname(__FILE__), '..', 'support', key + '.pub')
  step "'rhc sshkey add #{key} #{keyfile}' is run"
end

Given /^an SSH key "(.*?)" with the same content as "(.*?)" exists$/ do |existing_key, new_key|
end

When /^a new SSH key "(.*?)" is added as "(.*)"$/ do |keyfile, name|
  SshKey.add "#{name} #{keyfile}"
end

Then /^the output includes the key information for "(.*?)"$/ do |key|
  @sshkey_output.should match /Name: #{key}/
end

Then /^the output includes deprecation warning$/ do
  @sshkey_output.should match /deprecated/
end

Then /^the key "(.*?)" should exist$/ do |key|
  SshKey.show "#{key}"
  SshKey.sshkey_output.should =~ /Name: #{key}/
end

Then /^the SSH key "(.*?)" is deleted$/ do |key|
  SshKey.remove "#{key}"
end

Then /^the output includes the key information$/ do
  @sshkey_output.should match /Name:.*Type:.*Fingerprint:/m
end

Then /^the command exits with status code (\d+)$/ do |arg1|
  code = arg1.to_i
  @exitcode.should == code
end

