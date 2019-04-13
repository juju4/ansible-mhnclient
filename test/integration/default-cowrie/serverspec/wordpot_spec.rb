require 'serverspec'

# Required by serverspec
set :backend, :exec

geoloc_test = false

describe file('/var/log/supervisor/wordpot.out') do
  its(:content) { should match /Running on http:/ }
  its(:content) { should_not match /TypeError/ }
end

describe command('mongo hpfeeds -eval "db.auth_key.find({identifier: \'mnemosyne\'}).pretty();"') do
  its(:stdout) { should match /wordpot.events/ }
  its(:exit_status) { should eq 0 }
end

if geoloc_test
  describe command('mongo hpfeeds -eval "db.auth_key.find({identifier: \'geoloc\'}).pretty();"') do
    its(:stdout) { should match /wordpot.events/ }
    its(:exit_status) { should eq 0 }
  end
end
