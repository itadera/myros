abs_dirname() {
  local cwd="$(pwd)"
  local path="$1"

  while [ -n "$path" ]; do
    cd "${path%/*}"
    local name="${path##*/}"
    path="$(readlink "$name" || true)"
  done

  pwd -P
  cd "$cwd"
}

SCRIPT_DIR="$(abs_dirname "$0")"
IMAGE_NAME="mynoetic"
docker build -f $SCRIPT_DIR/Dockerfile -t $IMAGE_NAME . 
