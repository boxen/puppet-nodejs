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

  context "use alias" do
    let(:title) { "v0.6" }

    it do
      should contain_class("nodejs")

      should contain_nodejs__alias("v0.6").with({
        :ensure  => "present",
        :to => "v0.6.20"
      })
    end
  end

  context "compile depending on configuration" do
    let(:title) { "v0.6.20" }

    it do
      should contain_class("nodejs")

      should contain_nodejs("v0.6.20").with({
        :ensure  => "present",
        :compile => true
      })
    end
  end

  context "fallback compile with short version" do
    let(:title) { "v0.4.10" }

    it do
      should contain_class("nodejs")

      should contain_nodejs("v0.4.10").with({
        :ensure  => "present",
        :compile => true
      })
    end
  end

  context "non-default parameter values" do
    let(:params) do
      { :ensure => "absent", :version => "v0.8.8" }
    end

    it do
      should contain_nodejs("v0.8.8").with({
        :ensure  => "absent",
        :version => "v0.8.8"
      })
    end
  end
end
