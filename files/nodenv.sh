# Configure and activate nodenv. You know, for nodes.

export NODENV_ROOT=$BOXEN_HOME/nodenv

export PATH=$BOXEN_HOME/nodenv/bin:$PATH

export NODE_PATH=$BOXEN_HOME/nodenv/versions/$(nodenv version)/lib/

eval "$(nodenv init -)"

