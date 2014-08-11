# Public: Install a nodejs version via nodenv.
#         Versions < v0.8.x require compile => true to work.
#
# Usage:
#
#   nodejs::version { 'v0.10.0': }

define nodejs::version(
  $ensure  = present,
  $compile = false,
  $version = $title,
) {
  require nodejs

  $alias_hash = hiera_hash('nodejs::version::alias', {})

  if has_key($alias_hash, $version) {

    $to = $alias_hash[$version]

    nodejs::alias { $version:
      ensure => $ensure,
      to     => $to,
    }

  } else {

    nodejs { $version:
      ensure      => $ensure,
      compile     => $compile,
      nodenv_root => $::nodejs::nodenv_root,
      user        => $::nodejs::nodenv_user
    }

  }
}
