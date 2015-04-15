# Aliases a (usually shorter) node version to another
#
# Usage:
#
#     nodejs::alias { '0.10': to => '0.10.36' }

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

  file { "/opt/nodes/${version}":
    ensure  => $file_ensure,
    force   => true,
    target  => "/opt/nodes/${to}",
    require => Nodejs::Version[$to],
  }
}
