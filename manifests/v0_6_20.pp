# Public: Install nodejs v0.6.20
#
# Usage:
#
#   include nodejs::v0_6_20

class nodejs::v0_6_20 {
  nodejs::version { 'v0.6.20':
    compile => true
  }
}
