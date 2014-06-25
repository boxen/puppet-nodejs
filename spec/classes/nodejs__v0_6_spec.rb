require "spec_helper"

describe "nodejs::v0_6" do
  let(:facts) { default_test_facts }

  it do
    should contain_class("nodejs::v0_6_20")

    should contain_file("/test/boxen/nodenv/versions/v0.6").with({
      :ensure => "link",
      :target => "/test/boxen/nodenv/versions/v0.6.20"
    })
  end
end
