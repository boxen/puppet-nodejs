class nodejs::0-8 {
  require nvm

  $version = '0.8.8'

  nodejs { $version:
    ensure => installed
  }

  file { "${nvm::dir}/alias/v0.8":
    content => "v${version}",
    require => Nodejs[$version]
  }
}
