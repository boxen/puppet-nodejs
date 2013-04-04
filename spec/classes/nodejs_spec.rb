require "spec_helper"

describe "nodejs" do
  let(:facts) { default_test_facts }

  let(:root) { "/test/boxen/nodenv" }
  let(:versions) { "#{root}/versions" }

  it do
    should include_class("boxen::config")
    should include_class("nodejs::config")
    should include_class("nodejs::rehash")

    should contain_file(root).with_ensure("directory")
    should contain_file(versions).with_ensure("directory")

    should contain_file("/test/boxen/env.d/nodenv.sh").with_source("puppet:///modules/nodejs/nodenv.sh")

    should contain_exec("nodenv-setup-repo").with({
      :command => "git init . && git remote add origin https://github.com/wfarr/nodenv.git && git fetch -q origin && git reset --hard v0.2.2",
      :cwd     => root,
      :creates => "#{root}/bin/nodenv",
      :require => [
        "File[#{root}]",
        "Class[Git]"
      ]
    })

    should contain_exec("ensure-nodenv-version-v0.2.2").with({
      :command => "git fetch -q origin && git reset --hard v0.2.2",
      :unless  => "git describe --tags --exact-match `git rev-parse HEAD` | grep v0.2.2",
      :cwd     => root,
      :require => "Exec[nodenv-setup-repo]"
    })

    should contain_exec("purge nvm").with({
      :command => "rm -rf /test/boxen/nvm",
      :onlyif  => "test -d /test/boxen/nvm"
    })

    should contain_file("/test/boxen/env.d/nvm.sh").with_ensure("absent")
  end
end
