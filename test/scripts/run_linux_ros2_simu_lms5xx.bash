#!/bin/bash
printf "\033c"
pushd ../../../..
source /opt/ros/eloquent/setup.bash
source ./install/setup.bash

echo -e "run_simu_lms5xx.bash: starting lms5xx emulation\n"

# Start sick_scan emulator
python3 ./src/sick_scan_xd/test/emulator/test_server.py --scandata_file=./src/sick_scan_xd/test/emulator/scandata/20210302_lms511.pcapng.scandata.txt --scandata_frequency=20.0 --tcp_port=2112 & 
sleep 1

# Start rviz
rviz2 -d ./src/sick_scan_xd/test/emulator/config/rviz2_lms5xx.rviz &
sleep 1

# Start sick_scan driver for lms5xx
echo -e "Launching sick_scan sick_lms_1xx.launch\n"
# ros2 run sick_scan sick_generic_caller ./src/sick_scan_xd/launch/sick_lms_5xx.launch hostname:=192.168.0.111 &
# ros2 run sick_scan sick_generic_caller ./src/sick_scan_xd/launch/sick_lms_5xx.launch hostname:=127.0.0.1 sw_pll_only_publish:=False &
ros2 launch sick_scan sick_lms_5xx.launch.py hostname:=127.0.0.1 sw_pll_only_publish:=False &

# Shutdown
sleep 30
pkill rviz2
pkill -f ./test/emulator/test_server.py
killall sick_generic_caller 

popd

