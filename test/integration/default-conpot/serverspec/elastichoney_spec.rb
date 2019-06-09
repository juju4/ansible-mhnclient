require 'serverspec'

# Required by serverspec
set :backend, :exec

geoloc_test = false

describe process("elastichoney") do

  its(:user) { should eq "root" }

  it "is listening on port 9200" do
    expect(port(9200)).to be_listening
  end

end

describe command('mongo hpfeeds -eval "db.auth_key.find({identifier: \'mnemosyne\'}).pretty();"') do
  its(:stdout) { should match /elastichoney.events/ }
  its(:exit_status) { should eq 0 }
end

if geoloc_test
  describe command('mongo hpfeeds -eval "db.auth_key.find({identifier: \'geoloc\'}).pretty();"') do
    its(:stdout) { should match /elastichoney.events/ }
    its(:exit_status) { should eq 0 }
  end
end
