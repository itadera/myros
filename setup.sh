
if [ "$(id -u)" != "0" ]; then
  echo "Please run this script with sudo."
  exit 1
fi


SCRIPT_DIR=$(cd $(dirname $0); pwd)
HOME_DIR=$(getent passwd ${SUDO_USER:-$USER} | cut -d: -f6)

echo "Setting up ROS environment..."
echo "Script directory: $SCRIPT_DIR"
echo "Home directory: ${HOME_DIR}"


if ! grep -q "source $SCRIPT_DIR/ros_setup.zsh" ${HOME_DIR}/.zshrc ; then
  echo "" >> ${HOME_DIR}/.zshrc
  echo "# setup for ROS" >> ${HOME_DIR}/.zshrc
  echo "source $SCRIPT_DIR/ros_setup.zsh" >> ${HOME_DIR}/.zshrc
fi

# cp $SCRIPT_DIR/p10k.zsh ~/.p10k.zsh
ln -s -f $SCRIPT_DIR/p10k.zsh ${HOME_DIR}/.p10k.zsh


if ! grep -q "# setup for ROS" /etc/profile ; then
  echo "" >> /etc/profile 
  echo "# setup for ROS" >> /etc/profile 
  echo "export ROS_LOCALHOST_ONLY=1" >> /etc/profile 
  echo "export ROS_AUTOMATIC_DISCOVERY_RANGE=LOCALHOST" >> /etc/profile 
fi

