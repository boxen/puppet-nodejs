# (Internal) Installs node-build

class nodejs::build(
  $ensure = $nodejs::build::ensure,
  $prefix = $nodejs::build::prefix,
  $user   = $nodejs::build::user,
) {
  require nodejs

  repository { $prefix:
    ensure => $ensure,
    force  => true,
    source => 'nodenv/node-build',
    user   => $user,
  }

  ensure_resource('file', "${::nodejs::prefix}/cache/nodes", {
    'ensure' => 'directory',
    'owner'  => $user,
  })

}
