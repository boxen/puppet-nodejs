require "spec_helper"

describe "nodejs::v0_10" do
  let(:facts) { default_test_facts }

  it do
<<<<<<< HEAD
    should contain_class("nodejs::v0_10_31")
=======
    should contain_nodejs__version("v0.10.29")
>>>>>>> Remove version clases but aliases

    should contain_file("/test/boxen/nodenv/versions/v0.10").with({
      :ensure => "link",
      :target => "/test/boxen/nodenv/versions/v0.10.31"
    })
  end
end
