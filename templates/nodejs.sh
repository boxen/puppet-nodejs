# Put node-build on PATH
export PATH=<%= scope.lookupvar("::nodejs::build::prefix") %>/bin:$PATH

# Configure NODENV_ROOT and put NODENV_ROOT/bin on PATH
export NODENV_ROOT=<%= scope.lookupvar("::nodejs::nodenv::prefix") %>
export PATH=$NODENV_ROOT/bin:$PATH

# Load nodenv
eval "$(nodenv init -)"

export PATH=./node_modules/.bin:$PATH

# Helper for shell prompts and the like
current_node() {
  echo "$(nodenv version-name)"
}
