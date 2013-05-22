# Public: Make sure a certain nodejs version is installed and configured
#         to be used in a certain directory.
#
# Usage:
#
#   nodejs::local { '/path/to/somewhere': version => 'v0.10' }

define nodejs::local(
  $version = undef,
  $path    = $title,
  $ensure  = present
) {
  validate_re($ensure, '\A(present|absent)\z',
    'Ensure must be one of present or absent')

  if $ensure == present {
    validate_re($version, '\Av\d+\.\d+(\.\d+)*\z',
      'Version must be of the form vN.N(.N)')

    $klass = join(['nodejs', join(split($version, '\.'), '_')], '::')
    require $klass
  }

  validate_absolute_path($path)

  file { "${path}/.node-version":
    ensure  => $ensure,
    content => "${version}\n",
    replace => true
  }
}
