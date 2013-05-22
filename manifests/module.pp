# Public: Install a global npm module for a given version of nodejs
#
# Usage:
#
#   nodejs::module { 'bower for v0.10': node_version => 'v0.10' }

define nodejs::module(
  $node_version,
  $module = $title,
  $ensure = installed
) {
  $klass = join(['nodejs', join(split($node_version, '\.'), '_')], '::')
  require $klass

  npm_module { $name:
    ensure       => $ensure,
    module       => $module,
    node_version => $node_version,
    nodenv_root  => $nodejs::nodenv_root,
    user         => $nodejs::nodenv_user,
    provider     => nodenv
  }
}
