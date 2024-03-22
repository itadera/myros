DIST_ros1="noetic"
DIST_ros2="humble"

SCRIPT_DIR=$(cd $(dirname $0); pwd)
MODE_FILE=".ros2_mode"

if [ -f $SCRIPT_DIR/$MODE_FILE ]; then
  MODE="ros2"
else
  MODE="ros1"
fi

echo "Current ROS mode is $MODE"


if [[ "$MODE" == "ros1" ]]; then
  source /opt/ros/$DIST_ros1/setup.zsh
  sws=(`ls -1 $SCRIPT_DIR/ros1/`)
  for sw_name in "${sws[@]}"; do
    source $SCRIPT_DIR/ros1/${sw_name}/devel/setup.zsh --extended
  done
  cd $SCRIPT_DIR/ros1
elif [[ "$MODE" == "ros2" ]]; then
  source /opt/ros/$DIST_ros2/setup.zsh
  sws=(`ls -1 $SCRIPT_DIR/ros2/`)
  for sw_name in "${sws[@]}"; do
    source $SCRIPT_DIR/ros2/${sw_name}/install/setup.zsh --extended
  done

  # argcomplete for ros2 & colcon
  eval "$(register-python-argcomplete3 ros2)"
  eval "$(register-python-argcomplete3 colcon)"

  cd $SCRIPT_DIR/ros2
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

alias rd_run="sh $SCRIPT_DIR/docker/$MODE/run.sh"
alias rd_build="sh $SCRIPT_DIR/docker/$MODE/build.sh"
alias rd_exec="sh $SCRIPT_DIR/docker/$MODE/exec.sh"
