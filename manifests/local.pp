# Set a directory's default node version via nodenv.
# Automatically ensures that node version is installed via nodenv.
#
# Usage:
#
#     nodejs::local { '/path/to/a/thing': version => '0.10.36' }

define nodejs::local($version = undef, $ensure = present) {
  include nodejs

  case $version {
    'system': { $_node_local_require = undef }
    undef:    { $_node_local_require = undef }
    default:  {
      ensure_resource('nodejs::version', $version)
      $_node_local_require = Nodejs::Version[$version]
    }
  }

  file {
    "${name}/.node-version":
      ensure  => $ensure,
      content => "${version}\n",
      replace => true,
      require => $_node_local_require ;

    "${name}/.nodenv-version":
      ensure  => absent,
      before  => File["${name}/.node-version"],
      require => $_node_local_require ;
  }
}
