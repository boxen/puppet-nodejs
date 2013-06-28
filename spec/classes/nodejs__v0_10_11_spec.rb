require "spec_helper"

describe "nodejs::v0_10_11" do
  let(:facts) { default_test_facts }

  it do
    should contain_nodejs__version("v0.10.11")
  end
end
