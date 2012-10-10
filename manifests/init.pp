define nodejs($ensure  = 'installed') {
  require nvm

  $version   = "v${name}"
  $archive   = "${version}.tar.bz2"
  $os        = $::macosx_productversion_major
  $url       = "http://s3.amazonaws.com/boxen-downloads/nvm/${os}/${archive}"
  $curl      = "(curl ${url} | tar xjf -)"
  $install   = "(. ${nvm::dir}/nvm.sh && nvm install ${version})"
  $srcdir    = "${nvm::dir}/src/node-${version}"

  # FIX: Figure out a way to remove any aliases too.

  if $ensure == 'absent' {
    file { ["${nvm::dir}/#{version}", $srcdir, "${srcdir}.tar.gz"]:
      ensure => absent,
      force  => true
    }
  } else {
    exec { "nvm-install-${name}":
      command  => "${curl} || ${install}",
      cwd      => $nvm::dir,
      provider => 'shell',
      timeout  => 0,
      creates  => "${nvm::dir}/${version}"
    }
  }
}
