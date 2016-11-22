# Configure and activate nodenv. You know, for nodes.

set -gx NODENV_ROOT $BOXEN_HOME/nodenv

set -gx PATH $BOXEN_HOME/nodenv/bin $PATH

source (nodenv init - | psub)

set -gx PATH ./node_modules/.bin $PATH
