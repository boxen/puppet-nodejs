require "spec_helper"

describe "nodejs::v0_4" do
  let(:facts) { default_test_facts }

  it do
    should contain_class("nodejs::v0_4_10")

    should contain_file("/test/boxen/nodenv/versions/v0.4").with({
      :ensure => "link",
      :target => "/test/boxen/nodenv/versions/v0.4.10"
    })
  end
end
