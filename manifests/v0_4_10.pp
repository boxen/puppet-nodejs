# Public: Install nodejs v0.4.10
#
# Usage:
#
#   include nodejs::v0_4_10

class nodejs::v0_4_10 {
  nodejs::version { 'v0.4.10':
    compile => true
  }
}
