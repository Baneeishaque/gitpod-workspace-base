./installAria2.bash
./copyConfigurations.bash
# TODO: Get session file path from conf file
touch /workspace/aria2_repository/session.txt
aria2c --conf-path=/workspace/configurations-private/aria2/aria2_linux_gitpod.conf
# ssh -L 6800:localhost:6800 'gp ssh'
