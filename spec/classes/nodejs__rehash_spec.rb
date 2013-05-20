require "spec_helper"

describe "nodejs::rehash" do
  let(:facts) { default_test_facts }

  let(:root)  { "/test/boxen/nodenv" }

  it do
    shared_params = {
      :refreshonly => true,
      :command     => "NODENV_ROOT=#{root} #{root}/bin/nodenv rehash",
      :provider    => "shell"
    }

    should contain_exec("nodenv rehash after nodejs install").with(shared_params)
    should contain_exec("nodenv rehash after npm module install").with(shared_params)
  end
end
