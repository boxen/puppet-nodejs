# Aliases a (usually shorter) ruby version to another
#
# Usage:
#
#     nodejs::alias { 'v0.10': to => 'v0.10.29' }

define nodejs::alias(
  $ensure  = 'installed',
  $to      = undef,
  $version = $title,
) {

  require nodejs

  if $to == undef {
    fail('to cannot be undefined')
  }

  if $ensure != 'absent' {
    ensure_resource('nodejs::version', $to)
  }

  $file_ensure = $ensure ? {
    /^(installed|present)$/ => 'symlink',
    default                 => $ensure,
  }

  file { "${nodejs::nodenv_root}/versions/${version}":
    ensure  => $file_ensure,
    force   => true,
    owner   => $nodejs::nodenv_user,
    target  => "${nodejs::nodenv_root}/versions/${to}",
    require => Nodejs::Version[$to]
  }
}
