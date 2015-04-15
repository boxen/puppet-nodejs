Puppet::Type.newtype(:npm_module) do
  @doc = ""

  ensurable do
    newvalue :present do
      provider.create
    end

    newvalue :absent do
      provider.destroy
    end

    defaultto :present

    aliasvalue(:installed, :present)
    aliasvalue(:uninstalled, :absent)

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

  newparam(:name) do
    isnamevar

    validate do |v|
      unless v.is_a? String
        raise Puppet::ParseError,
          "Expected name to be a String, got a #{v.class.name}"
      end
    end
  end

  newparam(:module) do
    validate do |v|
      unless v.is_a? String
        raise Puppet::ParseError,
          "Expected module to be a String, got a #{v.class.name}"
      end
    end
  end

  newparam(:node_version) do
    validate do |v|
      unless v.is_a? String
        raise Puppet::ParseError,
          "Expected node_version to be a String, got a #{v.class.name}"
      end
    end
  end

  newparam(:version) do
    defaultto '>= 0'

    validate do |v|
      unless v.is_a? String
        raise Puppet::ParseError,
          "Expected version to be a String, got a #{v.class.name}"
      end
    end
  end

  autorequire :nodejs do
    if @parameters.include?(:node_version) && node_version = @parameters[:node_version].to_s
      if node_version == "*"
        catalog.resources.find_all { |resource| resource.type == 'Nodejs' }
      else
        Array.new.tap do |a|
          a << node_version if catalog.resource(:nodejs, node_version)
        end
      end
    end
  end
end
