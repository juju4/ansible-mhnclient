require 'serverspec'

# Required by serverspec
set :backend, :exec

glastopf_test = false
geoloc_test = false

### FIXME! can't select right python process
#describe process("python") do
#
#  its(:user) { should eq "nobody" }
#  its(:args) { should match /glastopf-runner/ }
#
#  it "is listening on port 80" do
#    expect(port(80)).to be_listening
#  end
#
#end

#describe command('curl http://127.0.0.1/') do
#  its(:stdout) { should match /xxx/ }
#end

if glastopf_test
  describe file('/var/log/supervisor/glastopf.out') do
    its(:content) { should_not match /Error/ }
    its(:content) { should_not match /ImportError: No module named/ }
  end

  describe port(80), :if => os[:family] == 'ubuntu' && os[:release] == '16.04' do
    it { should be_listening }
  end

  describe command('mongo hpfeeds -eval "db.auth_key.find({identifier: \'mnemosyne\'}).pretty();"') do
    its(:stdout) { should match /glastopf.events/ }
    its(:exit_status) { should eq 0 }
  end

  if geoloc_test
    describe command('mongo hpfeeds -eval "db.auth_key.find({identifier: \'geoloc\'}).pretty();"') do
      its(:stdout) { should match /glastopf.events/ }
      its(:exit_status) { should eq 0 }
    end
  end
end
