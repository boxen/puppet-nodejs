require "spec_helper"

describe "nodejs::version" do
  let(:facts) { default_test_facts }
  let(:title) { "v0.10.0" }

  it do
    should contain_class("nodejs")

    should contain_nodejs("v0.10.0").with({
      :ensure  => "present",
      :compile => false
    })
  end

  context "non-default parameter values" do
    let(:params) do
      { :ensure => "absent", :compile => true, :version => "v0.8.8" }
    end

    it do
      should contain_nodejs("v0.8.8").with({
        :ensure  => "absent",
        :compile => true,
        :version => "v0.8.8"
      })
    end
  end
end
