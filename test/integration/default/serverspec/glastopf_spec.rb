require 'serverspec'

# Required by serverspec
set :backend, :exec

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

describe port(80), :if => os[:family] == 'ubuntu' && os[:release] == '16.04' do
  it { should be_listening }
end

