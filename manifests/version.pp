# Public: Install a nodejs version via nodenv.
#         Versions < v0.8.x require compile => true to work.
#
# Usage:
#
#   nodejs::version { 'v0.10.0': }

define nodejs::version(
  $ensure  = present,
  $version = $title,
) {

  require nodejs

  $alias_hash = hiera_hash('nodejs::version::alias', {})
  $compile_hash = hiera_hash('nodejs::version::compile', {})


  if has_key($compile_hash, $version) {
    $compile_node = $compile_hash[$version]
  }
  else {

    if $version =~ /^v?(\d+\.\d+)\.(\d+)$/ {
      $short_version = "v${1}"
    }

    if $short_version and has_key($compile_hash, $short_version) {
      $compile_node = $compile_hash[$short_version]
    }
    else {
      $compile_node = false
    }
  }

  if has_key($alias_hash, $version) {

    $to = $alias_hash[$version]

    nodejs::alias { $version:
      ensure  => $ensure,
      to      => $to
    }

  } else {

    nodejs { $version:
      ensure      => $ensure,
      compile     => $compile_node,
      nodenv_root => $::nodejs::nodenv_root,
      user        => $::nodejs::nodenv_user
    }

  }
}
