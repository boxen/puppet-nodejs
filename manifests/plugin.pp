# Public: Install an nodenv plugin.
#
# Usage:
#
#       nodejs::plugin { 'nodenv-vars':
#         ensure => 'v0.1.0',
#         source => 'johnbellone/nodenv-vars'
#       }

define nodejs::plugin($ensure, $source) {
  include nodejs

  repository { "${nodejs::nodenv_root}/plugins/${name}":
    ensure => $ensure,
    force  => true,
    source => $source,
    user   => $nodejs::user
  }
}
