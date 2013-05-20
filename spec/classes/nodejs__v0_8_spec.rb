require "spec_helper"

describe "nodejs::v0_8" do
  let(:facts) { default_test_facts }

  it do
    should include_class("nodejs::v0_8_8")

    should contain_file("/test/boxen/nodenv/versions/v0.8").with({
      :ensure => "link",
      :target => "/test/boxen/nodenv/versions/v0.8.8"
    })
  end
end
