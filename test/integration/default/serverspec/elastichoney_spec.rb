require 'serverspec'

# Required by serverspec
set :backend, :exec

describe process("elastichoney") do

  its(:user) { should eq "root" }

  it "is listening on port 9200" do
    expect(port(9200)).to be_listening
  end

end

