Puppet::Type.newtype :npm_module do
  ensurable do
    newvalue :installed, :event => :module_installed do
      provider.install
    end

    newvalue :uninstalled, :event => :module_removed do
      provider.uninstall
    end

    newvalue(/./) do
      current = provider.query[:ensure]

      begin
        provider.install
      rescue => e
        self.fail "Could not install: #{e}"
      end

      unless current == provider.query[:ensure]
        if current == :absent
          :module_installed
        else
          :module_changed
        end
      end
    end

    aliasvalue :present, :installed
    aliasvalue :absent,  :uninstalled

    defaultto :installed

    def retrieve
      provider.query[:ensure]
    end

    def insync?(is)
      @should.each { |should|
        case should
        when :present, :installed
          return true unless is == :absent
        when :absent, :uninstalled
          return true if is == :absent
        when *Array(is)
          return true
        end
      }
      false
    end
  end

  newparam :name do
    isnamevar
  end

  newparam :module do
  end

  newparam :node_version do
  end

  newparam :nodenv_root do
  end

  newparam :user do
  end

  autorequire :nodejs do
    [@parameters[:node_version].value]
  end

  autorequire :user do
    Array.new.tap do |a|
      if @parameters.include?(:user) && user = @parameters[:user].to_s
        a << user if catalog.resource(:user, user)
      end
    end
  end

  def exists?
    @provider.query[:ensure] != :absent
  end

  def initialize(*args)
    super
    self[:notify] = [ "Exec[nodenv rehash after npm module install]" ]
  end
end
