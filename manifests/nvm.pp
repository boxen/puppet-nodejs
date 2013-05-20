# Internal: NVM conflicts with our reality, so purge the one this moudle
# used to install
#
class nodejs::nvm {
  include nodejs

  if $::osfamily == 'Darwin' {
    include boxen::config

    file { "${boxen::config::envdir}/nvm.sh":
      ensure => absent
    }
  }

  exec { 'purge nvm':
    command => "rm -rf ${nodejs::nvm_root}",
    onlyif  => "test -d ${nodejs::nvm_root}"
  }
}
