require "spec_helper"

describe "nodejs" do
  let(:facts) { default_test_facts }

  let(:root) { "/test/boxen/nodenv" }
  let(:versions) { "#{root}/versions" }

  it do
    should contain_class("nodejs::rehash")
    should contain_class("nodejs::nvm")

    should contain_repository(root).with({
      :ensure => "v0.3.3",
      :force  => true,
      :source => "wfarr/nodenv",
      :user   => "testuser"
    })

    should contain_file(versions).with_ensure("directory")

    should contain_file("/test/boxen/env.d/nodenv.sh").with_ensure("absent")
    should contain_boxen__env_script("nodejs").with_source("puppet:///modules/nodejs/nodenv.sh")
  end

  context "Linux" do
    let(:facts) { default_test_facts.merge(:osfamily => "Linux") }

    it do
      should_not contain_boxen__env_script("nodejs")
    end
  end
end
