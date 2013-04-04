Puppet::Type.newtype :npm_module do
  ensurable do
    newvalue :installed, :event => :module_installed do
      provider.install
    end

    newvalue :uninstalled, :event => :module_removed do
      provider.uninstall
    end

    newvalue(/\A\d+\.\d+\.\d+\Z/) do
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
        when :present
          return true unless is == :absent
        when :absent
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

  autorequire :nodejs do
    [@parameters[:node_version].value]
  end

  def exists?
    @provider.query[:ensure] != :absent
  end

  def initialize(*args)
    super
    self[:notify] = [ "Exec[nodenv rehash after npm module install]" ]
  end
end
