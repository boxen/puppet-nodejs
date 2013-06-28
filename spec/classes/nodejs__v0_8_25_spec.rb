require "spec_helper"

describe "nodejs::v0_8_25" do
  let(:facts) { default_test_facts }

  it do
    should contain_nodejs__version("v0.8.25")
  end
end
