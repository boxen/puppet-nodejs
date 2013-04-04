require "spec_helper"

describe "nodejs::v0_4_10" do
  let(:facts) { default_test_facts }

  it do
    should contain_nodejs__version("v0.4.10").with_compile(true)
  end
end
