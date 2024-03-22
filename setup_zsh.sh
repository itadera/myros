SCRIPT_DIR=$(cd $(dirname $0); pwd)

echo "" >> ~/.zshrc
echo "# setup for ROS" >> ~/.zshrc
echo "source $SCRIPT_DIR/ros_setup.zsh" >> ~/.zshrc

cp $SCRIPT_DIR/p10k.zsh ~/.p10k.zsh
