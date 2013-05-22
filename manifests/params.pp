# Public: Configuration for NodeJS module

class nodejs::params {
  case $::osfamily {
    Darwin: {
      include boxen::config

      $nodenv_user = $::boxen_user
      $nodenv_root = "${boxen::config::home}/nodenv"
    }

    default: {
      $nodenv_user = 'root'
      $nodenv_root = '/usr/local/share/nodenv'
    }
  }

  $nodenv_version = 'v0.3.3'

  # Deprecated variables

  $nvm_root = $::osfamily ? {
    'Darwin' => "${boxen::config::home}/nvm",
    default  => '/usr/local/share/nvm'
  }
}
