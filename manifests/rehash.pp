# Private: Adds rehash exec hooks for after nodejs version or npm module installs

class nodejs::rehash {
  include nodejs

  exec {
    [
      'nodenv rehash after nodejs install',
      'nodenv rehash after npm module install'
    ]:
      refreshonly => true,
      command     => "NODENV_ROOT=${nodejs::nodenv_root} ${nodejs::nodenv_root}/bin/nodenv rehash",
      provider    => shell ;
  }

  Nodejs <| |> ~>
    Exec['nodenv rehash after nodejs install'] ->
    Npm_module <| |>
}
