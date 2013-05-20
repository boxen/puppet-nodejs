require "puppet/util/execution"

Puppet::Type.type(:nodejs).provide :nodenv do
  include Puppet::Util::Execution

  optional_commands :nodenv => "nodenv"

  def create
    command = [
      command(:nodenv),
      "install",
      @resource[:version]
    ]

    command << "--source" if @resource[:compile]

    execute command, command_opts
  end

  def destroy
    command = [
      command(:nodenv),
      "uninstall",
      @resource[:version]
    ]

    execute command, command_opts
  end

  def exists?
    File.directory? \
      "#{@resource[:nodenv_root]}/versions/#{@resource[:version]}"
  end

  def command_opts
    {
      :combine            => true,
      :custom_environment => {
        "NODENV_ROOT" => @resource[:nodenv_root],
        "PATH"        => "#{@resource[:nodenv_root]}/bin:/usr/bin:/usr/sbin:/bin:/sbin"
      },
      :failonfail         => true,
      :uid                => @resource[:user]
    }
  end
end
