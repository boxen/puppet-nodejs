class nodejs::0-6 {
  require nvm

  $version = '0.6.20'

  nodejs { $version:
    ensure => installed
  }

  file { "${nvm::dir}/alias/v0.6":
    content => "v${version}",
    require => Nodejs[$version]
  }
}
