# Public: node::definition allows you to install a node-build definition.
#
#   source =>
#     The puppet:// source to install from. If undef, looks in
#     puppet:///modules/node/definitions/${name}.

define nodejs::definition(
  $source = undef,
) {
  include nodejs
  include nodejs::build

  $source_path = $source ? {
    undef   => "puppet:///modules/nodejs/definitions/${name}",
    default => $source
  }

  file { "${nodejs::build::prefix}/share/node-build/${name}":
    source  => $source_path
  }
}
