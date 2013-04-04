require "spec_helper"

describe "nodejs::v0_6_20" do
  let(:facts) { default_test_facts }

  it do
    should contain_nodejs__version("v0.6.20").with_compile(true)
  end
end
