require "fileutils"

require 'puppet/util/execution'

Puppet::Type.type(:nodejs).provide(:nodebuild) do
  include Puppet::Util::Execution

  def self.nodelist
    @nodelist ||= Dir["/opt/nodes/*"].map do |node|
      if File.directory?(node) && File.executable?("#{node}/bin/node")
        File.basename(node)
      end
    end.compact
  end

  def self.instances
    nodelist.map do |node|
      new({
        :name     => node,
        :version  => node,
        :ensure   => :present,
        :provider => "nodebuild",
      })
    end
  end

  def query
    if self.class.nodelist.member?(version)
      { :ensure => :present, :name => version, :version => version}
    else
      { :ensure => :absent,  :name => version, :version => version}
    end
  end

  def create
    destroy if File.directory?(prefix)

    if Facter.value(:offline) == "true"
      if File.exist?("#{cache_path}/node-#{version}.tar.gz")
        build_node
      else
        raise Puppet::Error, "Can't install node because we're offline and the tarball isn't cached"
      end
    else
      try_to_download_precompiled_node || build_node
    end
  rescue => e
    raise Puppet::Error, "install failed with a crazy error: #{e.message} #{e.backtrace}"
  end

  def destroy
    FileUtils.rm_rf prefix
  end

private
  def try_to_download_precompiled_node
    Puppet.debug("Trying to download precompiled node for #{version}")
    output = execute "curl --silent --fail #{precompiled_url} >#{tmp} && tar xjf #{tmp} -C /opt/nodes", command_options.merge(:failonfail => false)

    output.exitstatus == 0
  ensure
    FileUtils.rm_f tmp
  end

  def build_node
    execute "#{node_build} #{version} #{prefix}", command_options.merge(:failonfail => true)
  end

  def tmp
    "/tmp/node-#{version}.tar.bz2"
  end

  def precompiled_url
    base = Facter.value(:boxen_download_url_base) ||
      "https://#{Facter.value(:boxen_s3_host)}/#{Facter.value(:boxen_s3_bucket)}"

    %W(
      #{base}
      /
      nodes
      /
      #{Facter.value(:operatingsystem)}
      /
      #{os_release}
      /
      #{CGI.escape(version)}.tar.bz2
    ).join("")
  end

  def os_release
    case Facter.value(:operatingsystem)
    when "Darwin"
      Facter.value(:macosx_productversion_major)
    when "Debian", "Ubuntu"
      Facter.value(:lsbdistcodename)
    else
      Facter.value(:operatingsystem)
    end
  end

  def node_build
    @resource[:node_build]
  end

  def command_options
    {
      :combine            => true,
      :custom_environment => environment,
      :uid                => @resource[:user],
      :failonfail         => true,
    }
  end

  def environment
    return @environment if defined?(@environment)

    @environment = Hash.new

    @environment["NODE_BUILD_CACHE_PATH"] = cache_path

    @environment.merge!(@resource[:environment])
  end

  def cache_path
    @cache_path ||= if Facter.value(:boxen_home)
      "#{Facter.value(:boxen_home)}/cache/nodes"
    else
      "/tmp/nodes"
    end
  end

  def version
    @resource[:version]
  end

  def prefix
    "/opt/nodes/#{version}"
  end
end
