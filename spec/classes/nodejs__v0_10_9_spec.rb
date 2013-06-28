require "spec_helper"

describe "nodejs::v0_10_9" do
  let(:facts) { default_test_facts }

  it do
    should contain_nodejs__version("v0.10.9")
  end
end
