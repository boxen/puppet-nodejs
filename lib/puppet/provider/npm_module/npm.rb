require 'puppet/util/execution'

Puppet::Type.type(:npm_module).provide(:npm) do
  include Puppet::Util::Execution
  desc ""

  def self.node_versions
    Dir["/opt/nodes/*"].map do |node|
      File.basename(node)
    end
  end

  def node_versions
    self.class.node_versions
  end

  def self.modulelist
    return @modulelist if defined?(@modulelist)

    mapping = Hash.new { |h,k| h[k] = {} }

    Dir["/opt/nodes/*"].each do |node|
      v = File.basename(node)
      mapping[v] = Array.new

      begin
        packages = JSON.parse(npmlist(v))["dependencies"]
        unless packages.nil?
          packages.each do |package, attrs|
            mapping[v] << {
              :module => package,
              :version => attrs["version"]
            }
          end
        end
      rescue Puppet::ExecutionFailure => e
        raise Puppet::Error, "Could not list node packages: #{e}"
      end
    end

    @modulelist = mapping
  end

  def self.instances
    return @instances if defined?(@instances)

    all_modules = Array.new

    modulelist.each do |r, modules|

      modules.each do |m|
        all_modules << new({
          :name         => "#{m[:module]} for #{r}",
          :module       => m[:module],
          :ensure       => :installed,
          :version      => m[:version],
          :node_version => r,
          :provider     => :npm,
        })
      end
    end

    @instances = all_modules
  end

  def modulelist
    self.class.modulelist
  end

  def instances
    self.class.instances
  end

  def query
    if @resource[:node_version] == "*"
      installed = node_versions.all? { |r| installed_for? r }
    else
      installed = installed_for? @resource[:node_version]
    end
    {
      :name         => "#{@resource[:module]} for all nodes",
      :ensure       => installed ? :present : :absent,
      :version      => @resource[:version],
      :module      => @resource[:module],
      :node_version => @resource[:node_version],
    }

  rescue => e
    raise Puppet::Error, "#{e.message}: #{e.backtrace.join('\n')}"
  end

  def create
    if Facter.value(:offline) == "true"
      raise Puppet::Error, "Can't install modules because we're offline"
    else
      if @resource[:node_version] == "*"
        target_versions = node_versions
      else
        target_versions = [@resource[:node_version]]
      end
      target_versions.reject { |r| installed_for? r }.each do |node|
        npm "install '#{@resource[:module]}'@'#{@resource[:version]}'", node
      end
    end
  rescue => e
    raise Puppet::Error, "#{e.message}: #{e.backtrace.join("\n")}"
  end

  def destroy
    if @resource[:node_version] == "*"
      target_versions = node_versions
    else
      target_versions = [@resource[:node_version]]
    end
    target_versions.select { |r| installed_for? r }.each do |node|
      npm "uninstall '#{@resource[:module]}'@'#{@resource[:version]}'", node
    end
  end

private
  # Override default `execute` to run super method in a clean
  # environment without Bundler, if Bundler is present
  # def execute(*args)
  #   if Puppet.features.bundled_environment?
  #     Bundler.with_clean_env do
  #       super
  #     end
  #   else
  #     super
  #   end
  # end

  # # Override default `execute` to run super method in a clean
  # # environment without Bundler, if Bundler is present
  # def self.execute(*args)
  #   if Puppet.features.bundled_environment?
  #     Bundler.with_clean_env do
  #       super
  #     end
  #   else
  #     super
  #   end
  # end

  def npm(command, node_version, failonfail = true)
    bindir = "/opt/nodes/#{node_version}/bin"
    execute "#{bindir}/npm #{command} --global", {
      :combine            => true,
      :uid                => user,
      #Npm versions greater than 0.10.26 return 1 when no dependencies are returned
      :failonfail         => failonfail,
      :override_locale    => false,
      :custom_environment => {
        "PATH" => env_path(bindir),
        "LANG" => "en_US.UTF-8"
      }
    }
  end

  def self.npmlist(node_version)
    #Npm versions greater than 0.10.26 return 1 when no dependencies are returned
    # npm "list --json --depth=0 --silent", node_version, SemVer.new(node_version_long) < SemVer.new('0.10.26')
    bindir = "/opt/nodes/#{node_version}/bin"
    execute "#{bindir}/npm list --global --json --depth=0 --silent", {
      :combine            => true,
      :uid                => user,
      #Npm versions greater than 0.10.26 return 1 when no dependencies are returned
      :failonfail         => false,
      :override_locale    => false,
      :custom_environment => {
        "PATH" => env_path(bindir),
        "LANG" => "en_US.UTF-8"
      }
    }
  end

  # def node_version_long
  #   if /^(\d+)\.(\d+)$/ =~ @resource[:node_version]
  #     @resource[:node_version] + '.999999'
  #   else
  #     @resource[:node_version]
  #   end
  # end

  def self.user
    Facter.value(:boxen_user) || Facter.value(:id)
  end

  def user
    self.class.user
  end

  def version(v)
    Gem::Version.new(v)
  end

  def requirement
    Gem::Requirement.new(@resource[:version])
  end

  def installed_for?(node_version)
    installed_modules[node_version].any? { |m|
      m[:module] == @resource[:module] \
        && requirement.satisfied_by?(version(m[:version])) \
        && m[:node_version] == node_version
    }
  end

  def installed_modules
    @installed_modules ||= Hash.new do |installed_modules, node_version|
      installed_modules[node_version] = modulelist[node_version].map { |m|
        # p m
        {
          :module       => m[:module],
          :version      => m[:version],
          :node_version => node_version,
        }
      }
    end
  end

  def self.env_path(bindir)
    [bindir,
     "#{Facter.value(:boxen_home)}/bin",
     "/usr/bin", "/bin", "/usr/sbin", "/sbin"].join(':')
  end

  def env_path(bindir)
    self.class.env_path(bindir)
  end
end
