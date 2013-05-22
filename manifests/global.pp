# Public: specify the global node version as per nodenv
#
# Usage:
#
#   class { 'nodejs::global': version => 'v0.10.0' }

class nodejs::global($version = 'v0.10') {
  require nodejs

  $klass = join(['nodejs', join(split($version, '\.'), '_')], '::')
  require $klass

  validate_re($version, '\Av\d+\.\d+(\.\d+)*\z',
    'Version must be of the form vN.N(.N)')

  file { "${nodejs::nodenv_root}/version":
    ensure  => present,
    owner   => $nodejs::nodenv_user,
    mode    => '0644',
    content => "${version}\n",
  }
}
