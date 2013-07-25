# Configure and activate nodenv. You know, for nodes.

export NODENV_ROOT=$BOXEN_HOME/nodenv

export PATH=$BOXEN_HOME/nodenv/bin:$PATH

eval "$(nodenv init -)"

export PATH=node_modules/.bin:$PATH

