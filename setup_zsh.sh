SCRIPT_DIR=$(cd $(dirname $0); pwd)

echo "" >> ~/.zshrc
echo "# setup for ROS" >> ~/.zshrc
echo "source $SCRIPT_DIR/ros_setup.zsh" >> ~/.zshrc

