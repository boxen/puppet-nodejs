require "spec_helper"

describe "nodejs::v0_8" do
  let(:facts) { default_test_facts }

  it do
    should contain_class("nodejs::v0_8_26")

    should contain_file("/test/boxen/nodenv/versions/v0.8").with({
      :ensure => "link",
      :target => "/test/boxen/nodenv/versions/v0.8.26"
    })
  end
end
