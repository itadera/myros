DIST_ros1="noetic"
DIST_ros2="humble"

SCRIPT_DIR=$(cd $(dirname $0); pwd)
MODE_FILE=".ros2_mode"

if [ -f $SCRIPT_DIR/$MODE_FILE ]; then
  MODE="ros2"
else
  MODE="ros1"
fi

echo "Current ROS version is $MODE"


function source_ros1() {
  if [ -e /opt/ros/$DIST_ros1/setup.zsh ]; then
    source /opt/ros/$DIST_ros1/setup.zsh
  fi

  CATKIN_SETUP_UTIL_ARGS=--extend
  sws=(`ls -1 $SCRIPT_DIR/ros1/`)
  for sw_name in "${sws[@]}"; do
    source $SCRIPT_DIR/ros1/${sw_name}/devel/setup.zsh
  done

  # cd $SCRIPT_DIR/ros1
}

function source_ros2() {
  if [ -e /opt/ros/$DIST_ros2/setup.zsh ]; then
    source /opt/ros/$DIST_ros2/setup.zsh

    # argcomplete for ros2 & colcon
    eval "$(register-python-argcomplete3 ros2)"
    eval "$(register-python-argcomplete3 colcon)"

    ID=$1
    if [ $ID -eq 0 ]; then
      export ROS_LOCALHOST_ONLY=1
    else
      export ROS_DOMAIN_ID=$ID
    fi
  fi

  sws=(`ls -1 $SCRIPT_DIR/ros2/`)
  for sw_name in "${sws[@]}"; do
    source $SCRIPT_DIR/ros2/${sw_name}/install/setup.zsh --extended
  done

  # cd $SCRIPT_DIR/ros2
}


if [[ "$MODE" == "ros1" ]]; then
  source_ros1
elif [[ "$MODE" == "ros2" ]]; then
  source_ros2 0
fi

function swros() {
  if [[ "$1" == "ros1" ]]; then
    if [ -f $SCRIPT_DIR/$MODE_FILE ]; then
      command rm $SCRIPT_DIR/$MODE_FILE
      MODE=$1
    fi
  elif [[ "$1" == "ros2" ]]; then
    if [ ! -f $SCRIPT_DIR/$MODE_FILE ]; then
      command echo -n > $SCRIPT_DIR/$MODE_FILE
      MODE=$1
    fi
  else
    echo "ros1 or ros2?"
    return
  fi
  source ~/.zshrc
}

alias rd_run="bash $SCRIPT_DIR/docker/run.sh"
alias rd_build="bash $SCRIPT_DIR/docker/build.sh"
alias rd_exec="bash $SCRIPT_DIR/docker/exec.sh"

function myros() {
  if [[ "$1" == "sw" ]]; then
    swros $2
  elif [[ "$1" == "docker" ]]; then
    if [[ "$2" == "run" ]]; then
      rd_run $MODE
    elif [[ "$2" == "build" ]]; then
      rd_build $MODE
    elif [[ "$2" == "exec" ]]; then
      rd_exec $MODE
    else
      echo "run, build or exec?"
      return
    fi
  else
    echo "Current ROS version is $MODE"
    echo "sw or docker?"
    return
  fi
}

function _myros () {
  local -a val
  val=(sw docker)

  local -a val_sw
  val_sw=(ros1 ros2)

  local -a val_docker
  val_docker=(run build exec)

  _arguments '1: :->arg1' '2: :->arg2'

  case "$state" in
    arg1)
      _values 'command' $val
      ;;
    arg2)
      if [[ $words[2] == "sw" ]]; then
        _values 'ROS version' $val_sw
      elif [[ $words[2] == "docker" ]]; then
        _values 'Docker command' $val_docker
      fi
      ;;
  esac
}

compdef _myros myros

