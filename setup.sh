SCRIPT_DIR=$(cd $(dirname $0); pwd)

if ! grep -q "source $SCRIPT_DIR/ros_setup.zsh" ~/.zshrc ; then
  echo "" >> ~/.zshrc
  echo "# setup for ROS" >> ~/.zshrc
  echo "source $SCRIPT_DIR/ros_setup.zsh" >> ~/.zshrc
fi

# cp $SCRIPT_DIR/p10k.zsh ~/.p10k.zsh
ln -s -f $SCRIPT_DIR/p10k.zsh ~/.p10k.zsh
