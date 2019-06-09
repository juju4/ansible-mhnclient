require 'serverspec'

# Required by serverspec
set :backend, :exec

geoloc_test = false

describe file('/var/log/supervisor/snort.log') do
  its(:content) { should match /Running in IDS mode/ }
  its(:content) { should match /log_hpfeeds: authentication done./ }
  its(:content) { should_not match /(error|warn)/ }
end

describe command('mongo hpfeeds -eval "db.auth_key.find({identifier: \'mnemosyne\'}).pretty();"') do
  its(:stdout) { should match /snort.alerts/ }
  its(:exit_status) { should eq 0 }
end

if geoloc_test
  describe command('mongo hpfeeds -eval "db.auth_key.find({identifier: \'geoloc\'}).pretty();"') do
    its(:stdout) { should match /snort.alerts/ }
    its(:exit_status) { should eq 0 }
  end
end
