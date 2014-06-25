require "spec_helper"

describe "nodejs::local" do
  let(:facts) { default_test_facts }
  let(:title) { "/test/path" }
  let(:params) do
    { :version => "v0.10" }
  end

  it do
    should contain_class("nodejs::v0_10")

    should contain_file("#{title}/.node-version").with({
      :ensure  => "present",
      :content => "v0.10\n",
      :replace => true
    })
  end

  context "with invalid version" do
    let(:params) do
      { :version => "0.10.0" }
    end

    it do
      expect {
        should contain_file("#{title}/.node-version")
      }.to raise_error(Puppet::Error, /Version must be of the form vN\.N\(\.N\)/)
    end
  end

  context "with ensure absent" do
    let(:params) do
      { :ensure => "absent" }
    end

    it do
      should contain_file("#{title}/.node-version").with_ensure("absent")
    end
  end

  context "with invalid ensure" do
    let(:params) do
      { :ensure => "whatever" }
    end

    it do
      expect {
        should contain_file("#{title}/.node-version")
      }.to raise_error(Puppet::Error, /Ensure must be one of present or absent/)
    end
  end
end
