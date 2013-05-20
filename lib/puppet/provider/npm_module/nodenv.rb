require "json"
require "puppet/util/execution"

Puppet::Type.type(:npm_module).provide :nodenv do
  include Puppet::Util::Execution

  def npmlist options = {}
    unless File.directory? @resource[:nodenv_root]
      self.fail "NODENV_ROOT does not exist"
    end

    command = [
      npm,
      "list",
      "--global"
    ]

    command << options[:justme] if options.has_key? :justme
    command << "--json"
    command << "--silent"

    begin
      packages = JSON.parse(execute(command, command_opts))["dependencies"]
      Array.new.tap do |a|
        unless packages.nil?
          packages.each do |package, attrs|
            a << {
              :module => package,
              :ensure => attrs["version"]
            }
          end
        end
      end.compact
    rescue Puppet::ExecutionFailure => e
      raise Puppet::Error, "Could not list node packages: #{e}"
    end
  end

  def install
    command = [ npm, "install", "--global" ]

    if @resource[:ensure].is_a? Symbol
      command << @resource[:module]
    else
      command << "#{@resource[:module]}@#{@resource[:ensure]}"
    end

    execute command, command_opts
  end

  def query
    npmlist(:justme => @resource[:module]).detect { |r|
      r[:module] == @resource[:module]
    } || {:ensure => :absent}
  end

  def uninstall
    command = [ npm, "uninstall", "--global", @resource[:module] ]
    execute command, command_opts
  end

  def command_opts
    {
      :combine            => true,
      :custom_environment => {
        "NODENV_ROOT"    => @resource[:nodenv_root],
        "NODENV_VERSION" => @resource[:node_version]
      },
      :failonfail         => true,
      :uid                => @resource[:user]
    }
  end

  def npm
    "#{@resource[:nodenv_root]}/shims/npm"
  end
end
