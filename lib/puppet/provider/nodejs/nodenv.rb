require "puppet/util/execution"

Puppet::Type.type(:nodejs).provide :nodenv do
  include Puppet::Util::Execution

  optional_commands :nodenv => "nodenv"

  def create
    command = [
      "#{@resource[:nodenv_root]}/bin/nodenv",
      "install",
      @resource[:version]
    ]

    command << "--source" if @resource[:compile]

    if Puppet.version =~ /^3\./
      execute command, command_opts
    else
      withenv command_env do
        execute command
      end
    end
  end

  def destroy
    command = [
      "#{@resource[:nodenv_root]}/bin/nodenv",
      "uninstall",
      @resource[:version]
    ]

    if Puppet.version =~ /^3\./
      execute command, command_opts
    else
      withenv command_env do
        execute command
      end
    end
  end

  def exists?
    File.directory? \
      "#{@resource[:nodenv_root]}/versions/#{@resource[:version]}"
  end

  def command_opts
    {
      :combine            => true,
      :custom_environment => command_env,
      :failonfail         => true,
      :uid                => @resource[:user]
    }
  end

  def command_env
    {
      "NODENV_ROOT" => @resource[:nodenv_root],
      "PATH"        => "#{@resource[:nodenv_root]}/bin:/usr/bin:/usr/sbin:/bin:/sbin"
    }
  end
end
