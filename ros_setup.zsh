alias rd_run="bash $SCRIPT_DIR/docker/run.sh"
alias rd_build="bash $SCRIPT_DIR/docker/build.sh"
alias rd_exec="bash $SCRIPT_DIR/docker/exec.sh"
SCRIPT_DIR=$(cd $(dirname $0); pwd)
ROSMODE_FILE=".ros2_mode"

function ros_setup() {


  if [ -f "$SCRIPT_DIR/$ROSMODE_FILE" ]; then
    ROSMODE=$(sed -n 1p "$SCRIPT_DIR/$ROSMODE_FILE")
    DOMAIN_ID=$(sed -n 2p "$SCRIPT_DIR/$ROSMODE_FILE")
  else
    ROSMODE="noetic"
    DOMAIN_ID=0
  fi
  # echo "Current ROS version is $ROSMODE"

  if [[ "$ROSMODE" == "noetic" ]]; then
    source_ros1
  else
    source_ros2
  fi
}

function source_ros1() {
  if [ -e /opt/ros/$ROSMODE/setup.zsh ]; then
    source /opt/ros/$ROSMODE/setup.zsh
  fi

  CATKIN_SETUP_UTIL_ARGS=--extend
  sws=(`ls -1 $SCRIPT_DIR/src/$ROSMODE/`)
  for sw_name in "${sws[@]}"; do
    source $SCRIPT_DIR/src/$ROSMODE/${sw_name}/devel/setup.zsh
  done
}

function source_ros2() {
  if [ -e /opt/ros/$ROSMODE/setup.zsh ]; then
    source /opt/ros/$ROSMODE/setup.zsh

    if [[ $DOMAIN_ID -eq 0 ]]; then
      if [[ "$ROSMODE" == "humble" ]]; then
        export ROS_LOCALHOST_ONLY=1
      else
        export ROS_AUTOMATIC_DISCOVERY_RANGE=LOCALHOST
      fi
    else
      if [[ "$ROSMODE" == "humble" ]]; then
        export ROS_LOCALHOST_ONLY=0
      else
        export ROS_AUTOMATIC_DISCOVERY_RANGE=SUBNET
      fi
    fi
    export ROS_DOMAIN_ID=$DOMAIN_ID
        
  fi

  sws=(`ls -1 $SCRIPT_DIR/src/$ROSMODE/`)
  for sw_name in "${sws[@]}"; do
    source $SCRIPT_DIR/src/$ROSMODE/${sw_name}/install/local_setup.zsh --extended
  done
  
  if [[ "$ROSMODE" == "humble" ]]; then
       # argcomplete for ros2 & colcon
       if [ -e /opt/ros/$ROSMODE/setup.zsh ]; then
          eval "$(register-python-argcomplete3 ros2)"
          eval "$(register-python-argcomplete3 colcon)"
       fi

    # elif [[ "$ROSMODE" == "jazzy" ]]; then
    #   eval "$(register-python-argcomplete ros2)"
    #   eval "$(register-python-argcomplete colcon)"

  fi
  export RCUTILS_COLORIZED_OUTPUT=1

  # cd $SCRIPT_DIR/ros2
}



function swros() {
  if [ -f $SCRIPT_DIR/$ROSMODE_FILE ]; then
      command rm $SCRIPT_DIR/$ROSMODE_FILE
  fi

  if [[ "$1" == "noetic" ]]; then
    ;
  elif [[ "$1" == "humble" || "$1" == "jazzy" ]]; then

    command echo "$1" > $SCRIPT_DIR/$ROSMODE_FILE
    command echo "$DOMAIN_ID" >> $SCRIPT_DIR/$ROSMODE_FILE
    ROSMODE=$1
  else
    echo "noetic or humble or jazzy?"
    return
  fi
  source ~/.zshrc
}

function setid() {
  command sed -i '2d' $SCRIPT_DIR/$ROSMODE_FILE
  echo $1 >> $SCRIPT_DIR/$ROSMODE_FILE

  DOMAIN_ID=$1
  source_ros2
}



function myros() {
  if [[ "$1" == "switch" ]]; then
    swros $2
  elif [[ "$1" == "docker" ]]; then
    if [[ "$2" == "run" ]]; then
      rd_run $ROSMODE
    elif [[ "$2" == "build" ]]; then
      rd_build $ROSMODE
    elif [[ "$2" == "exec" ]]; then
      rd_exec $ROSMODE
    else
      echo "run, build, exec?"
      return
    fi
  elif [[ "$1" == "cd" ]]; then
    cd $SCRIPT_DIR/src/$ROSMODE/"$2"
  elif [[ "$1" == "setid" ]]; then
    setid $2
  else
    source ~/.zshrc
    echo "Current ROS version is $ROSMODE"
    return
  fi
}

function _myros () {
  local -a val
  val=(switch docker cd setid)

  local -a val_sw
  val_sw=(noetic humble jazzy)

  local -a val_docker
  val_docker=(run build exec)

  _arguments '1: :->arg1' '2: :->arg2'

  case "$state" in
    arg1)
      _values 'command' $val
      ;;
    arg2)
      if [[ $words[2] == "switch" ]]; then
        _values 'ROS distribution' $val_sw
      elif [[ $words[2] == "docker" ]]; then
        _values 'Docker command' $val_docker
      elif [[ $words[2] == "cd" ]]; then
        _files -W $SCRIPT_DIR/src/$ROSMODE
      fi
      ;;
  esac
}

compdef _myros myros


ros_setup
