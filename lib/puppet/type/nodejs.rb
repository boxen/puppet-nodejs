Puppet::Type.newtype :nodejs do
  ensurable do
    newvalue :present do
      provider.create
    end

    newvalue :absent do
      provider.destroy
    end

    defaultto :present
  end

  newparam :version do
    isnamevar

    validate do |value|
      unless value =~ /\Av\d+\.\d+\.\d+\z/
        raise Puppet::Error, "Version must be like vN.N.N, not #{value}"
      end
    end
  end

  newparam :compile do
    defaultto false

    validate do |value|
      unless value.is_a?(TrueClass) || value.is_a?(FalseClass)
        raise Puppet::Error, "Compile must be true or false"
      end
    end
  end

  newparam :user do
  end

  newparam :nodenv_root do
  end

  autorequire :repository do
    [@parameters[:nodenv_root].value]
  end

  autorequire :user do
    Array.new.tap do |a|
      if @parameters.include?(:user) && user = @parameters[:user].to_s
        a << user if catalog.resource(:user, user)
      end
    end
  end

  def initialize(*args)
    super
    self[:notify] = [ "Exec[nodenv rehash after nodejs install]" ]
  end
end
