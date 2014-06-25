require "spec_helper"

describe "nodejs::global" do
  let(:facts) { default_test_facts }

  it do
    should contain_class("nodejs::v0_10")

    should contain_file("/test/boxen/nodenv/version").with({
      :ensure  => "present",
      :owner   => "testuser",
      :mode    => "0644",
      :content => "v0.10\n"
    })
  end

  context "version number given through params" do
    let(:params) do
      {
        :version => "v0.8"
      }
    end

    it do
      should contain_class("nodejs::v0_8")

      should contain_file("/test/boxen/nodenv/version").with_content("v0.8\n")
    end
  end
end
