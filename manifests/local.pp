define nodejs::local($version, $ensure = present) {
  require join(['nodejs', join(split($version, '[.]'), '-')], '::')

  file { "${name}/.nvm-version":
    ensure  => $ensure,
    content => "v${version}\n",
    replace => true
  }
}
