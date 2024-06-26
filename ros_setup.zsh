DIST_ros1="noetic"
DIST_ros2="humble"

SCRIPT_DIR=$(cd $(dirname $0); pwd)
ROSMODE_FILE=".ros2_mode"

if [ -f $SCRIPT_DIR/$ROSMODE_FILE ]; then
  ROSMODE="ros2"
else
  ROSMODE="ros1"
fi

# echo "Current ROS version is $ROSMODE"


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


if [[ "$ROSMODE" == "ros1" ]]; then
  source_ros1
elif [[ "$ROSMODE" == "ros2" ]]; then
  source_ros2 0
fi

function swros() {
  if [[ "$1" == "ros1" ]]; then
    if [ -f $SCRIPT_DIR/$ROSMODE_FILE ]; then
      command rm $SCRIPT_DIR/$ROSMODE_FILE
      ROSMODE=$1
    fi
  elif [[ "$1" == "ros2" ]]; then
    if [ ! -f $SCRIPT_DIR/$ROSMODE_FILE ]; then
      command echo -n > $SCRIPT_DIR/$ROSMODE_FILE
      ROSMODE=$1
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
      rd_run $ROSMODE
    elif [[ "$2" == "build" ]]; then
      rd_build $ROSMODE
    elif [[ "$2" == "exec" ]]; then
      rd_exec $ROSMODE
    else
      echo "run, build or exec?"
      return
    fi
  elif [[ "$1" == "cd" ]]; then
    cd $SCRIPT_DIR/$ROSMODE/"$2"
  else
    echo "Current ROS version is $ROSMODE"
    return
  fi
}

function _myros () {
  local -a val
  val=(sw docker cd)

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
      elif [[ $words[2] == "cd" ]]; then
        _files -W $SCRIPT_DIR/$ROSMODE
      fi
      ;;
  esac
}

compdef _myros myros
