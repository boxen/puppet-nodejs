require "spec_helper"

describe "nodejs::v0_10_4" do
  let(:facts) { default_test_facts }

  it do
    should contain_nodejs__version("v0.10.4")
  end
end
