require "spec_helper"

describe "nodejs::module" do
  let(:facts) { default_test_facts }
  let(:title) { "bower for v0.10" }
  let(:params) do
    { :node_version => "v0.10", :module => "bower" }
  end

  it do
    should contain_class("nodejs::v0_10")

    should contain_npm_module("bower for v0.10").with({
      :ensure       => "installed",
      :module       => "bower",
      :node_version => "v0.10",
      :nodenv_root  => "/test/boxen/nodenv",
      :user         => "testuser",
      :provider     => "nodenv"
    })
  end
end
