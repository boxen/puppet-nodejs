class nodejs::0-4 {
  require nvm

  $version = '0.4.10'

  nodejs { $version:
    ensure => installed
  }

  file { "${nvm::dir}/alias/v0.4":
    content => "v${version}",
    require => Nodejs[$version]
  }
}
