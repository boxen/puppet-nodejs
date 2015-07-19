# Installs a node version with node-build..
# Takes ensure, env, and version params.
#
# Usage:
#
#     nodejs::version { '0.10.36': }

define nodejs::version(
  $ensure  = 'installed',
  $env     = {},
  $version = $name
) {
  require nodejs
  require nodejs::build

  $alias_hash = hiera_hash('nodejs::version::alias', {})

  if has_key($alias_hash, $version) {
    $to = $alias_hash[$version]

    nodejs::alias { $version:
      ensure => $ensure,
      to     => $to,
    }
  } else {

    # case $version {
    #   /jruby/: { require 'java' }
    #   default: { }
    # }

    $default_env = {
      'CC' => '/usr/bin/cc',
    }

    if $::operatingsystem == 'Darwin' {
      include homebrew::config
      include boxen::config
      ensure_resource('package', 'readline')
      Package['readline'] -> Nodejs <| |>
    }

    $hierdata = hiera_hash('nodejs::version::env', {})

    if has_key($hierdata, $::operatingsystem) {
      $os_env = $hierdata[$::operatingsystem]
    } else {
      $os_env = {}
    }

    if has_key($hierdata, $version) {
      $version_env = $hierdata[$version]
    } else {
      $version_env = {}
    }

    $_env = merge(merge(merge($default_env, $os_env), $version_env), $env)

    if has_key($_env, 'CC') and $_env['CC'] =~ /gcc/ {
      require gcc
    }

    nodejs { $version:
      ensure      => $ensure,
      environment => $_env,
      node_build  => "${nodejs::build::prefix}/bin/node-build",
      user        => $nodejs::user,
      provider    => nodebuild,
    }

  }

}
