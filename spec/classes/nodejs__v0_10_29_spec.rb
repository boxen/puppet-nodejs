require "spec_helper"

describe "nodejs::v0_10_29" do
  let(:facts) { default_test_facts }

  it do
    should contain_nodejs__version("v0.10.29")
  end
end
