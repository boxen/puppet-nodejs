require "spec_helper"

describe "nodejs::v0_8_17" do
  let(:facts) { default_test_facts }

  it do
    should contain_nodejs__version("v0.8.17")
  end
end
