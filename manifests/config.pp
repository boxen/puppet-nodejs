# Public: Include shared variables for working with nodejs
#
# Usage:
#
#   include nodejs::config

class nodejs::config {
  include boxen::config

  $root = "${boxen::config::home}/nodenv"
  $nodenv_version = 'v0.2.2'
}
