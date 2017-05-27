require 'serverspec'

# Required by serverspec
set :backend, :exec

describe file('/opt/cowrie/log/cowrie.log') do
  its(:content) { should match /hpclient server name/ }
  its(:content) { should match /Loaded output engine: hpfeeds/ }
#  its(:content) { should match /publishing metadata to hpfeeds/ }
  its(:content) { should match /Ready to accept SSH connections/ }
  its(:content) { should_not match /exceptions.ImportError/ }
end

describe command('mongo hpfeeds -eval "db.auth_key.find({identifier: \'mnemosyne\'}).pretty();"') do
  its(:stdout) { should match /cowrie.sessions/ }
## 2016/12 Not in https://github.com/threatstream/mhn/blob/master/scripts/install_mnemosyne.sh
#  its(:stdout) { should match /cowrie.alerts/ }
  its(:exit_status) { should eq 0 }
end
describe command('mongo hpfeeds -eval "db.auth_key.find({identifier: \'geoloc\'}).pretty();"') do
  its(:stdout) { should match /cowrie.sessions/ }
  its(:stdout) { should match /cowrie.alerts/ }
  its(:exit_status) { should eq 0 }
end
