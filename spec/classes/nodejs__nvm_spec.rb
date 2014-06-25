require "spec_helper"

describe "nodejs::nvm" do
  let(:facts) { default_test_facts }

  it do
    should contain_class("boxen::config")

    should contain_file("/test/boxen/env.d/nvm.sh").with_ensure("absent")

    should contain_exec("purge nvm").with({
      :command => "rm -rf /test/boxen/nvm",
      :onlyif  => "test -d /test/boxen/nvm"
    })
  end

  context "Linux" do
    let(:facts) { default_test_facts.merge(:osfamily => "Linux") }

    it do
      should_not contain_class("boxen::config")

      should_not contain_file("/test/boxen/env.d/nvm.sh")
    end
  end
end
