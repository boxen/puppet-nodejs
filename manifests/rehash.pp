# Private: Adds rehash exec hooks for after nodejs version or npm module installs

class nodejs::rehash {
  include nodejs::config

  exec {
    [
      'nodenv rehash after nodejs install',
      'nodenv rehash after npm module install'
    ]:
      refreshonly => true,
      command     => "NODENV_ROOT=${nodejs::config::root} ${nodejs::config::root}/bin/nodenv rehash",
      provider    => shell ;
  }

  Nodejs <| |> ~>
    Exec['nodenv rehash after nodejs install'] ->
    Npm_module <| |>
}
