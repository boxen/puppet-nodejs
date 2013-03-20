class nodejs::0-10 {
  require nvm

  $version = '0.10.0'

  nodejs { $version:
    ensure => installed
  }

  file { "${nvm::dir}/alias/v0.10":
    content => "v${version}",
    require => Nodejs[$version]
  }
}
