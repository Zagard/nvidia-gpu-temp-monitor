#! /bin/bash

### xterm -T "Nvidia Temp Monitor" -geometry "63x3-0+0" -bg "grey20" -e "nvtempmon.sh" &
######################################################################
# file name:    NvTempMon
# author:       Zagard
# copyright:    Copyright (c) 2017 Zagard
# license:      This code is distributed under MIT license, except
#                   nvidia.smi which is owned by NVIDIA Corporation.
#
# nvidia-smi:
#   copyright:
#       Copyright (c) 2011-2017, NVIDIA Corporation. All rights reserved.
#   license:
#       Redistribution and use in source and binary forms, with or
#           without modification, are permitted provided that the
#           following conditions are met:
#           Redistributions of source code must retain the above
#               copyright notice, this list of conditions and the following
#               disclaimer.
#           Redistributions in binary form must reproduce the above
#               copyright notice, this list of conditions and the following
#               disclaimer in the documentation and/or other materials
#               provided with the distribution.
#           Neither the name of the NVIDIA Corporation nor the names of
#               its contributors may be used to endorse or promote
#               products derived from this software without specific
#               prior written permission.
#       THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
#           "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT
#           NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
#           FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
#           SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
#           DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
#           CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
#           PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
#           DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
#           AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
#           LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
#           ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
#           IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# about:
#   NvTempMon is written to run as a bash-script specifically for the
#       Nvidia GTX1060 graphics card driver.  other graphics cards may
#       have different commands or temp thresholds.  the intention is
#       to display gpu and cpu temps in a simple to read format, and
#       will allow continous monitoring of gpu temperature and
#       automatically shutdown the computer if gpu temperatures near
#       the max specified.  warnings will be visual text in the
#       terminal window; and if able, audio through attached speakers.
#
# dependencies:
#   nvidia-smi  -   command included with nvidia driver
#   to verify, try running 'nvidia-smi' from the terminal.  if properly
#       installed on your system, you will receive output.  for
#       'nvidia-smi' support, please check with the driver provider.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
#   EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
#   MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
#   IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR
#   ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
#   CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
#   WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
# bug reports or requests:
#   please submit to https://www.github/zagard/nvidia-gpu-temp-monitor/
######################################################################

# initialize variables
loop=true
infinate_loop=true # false runs program once per call
shutdown=false
gpu1=""
gpu2=""
cpu1=""
cpu2=""
cpu3=""

function set_variables ()
{
gpu2=$(nvidia-smi -q | grep -io 'gpu current temp.*')
gpu1=${gpu2//[^0-9]/}
cpu3=$(sensors | grep -i package)
cpu2=${cpu3//[^0-9]/}
cpu1=${cpu2:1:2}
}

### MAIN ###
# continue loop while no error
while [ $loop = true ]
do
    # set variables to current values and clear screen
    clear
    set_variables
    # checking temperatures to display corresponding messages or perform action
    case $gpu1 in
        [0-7][0-9]|8[0-4])
            echo "GPU:  $gpu2"
        ;;
        # range is set to warn when 85 to 89 deg.
        8[5-9])
            echo "GPU:  $gpu2"
            echo "Status                      : WARNING !!"
            echo "                              GPU REACHING MAXIMUM TEMP!!"
            echo "                              WILL SHUTDOWN AT 90c+"
            ( speaker-test -t sine -f 1000 )& pid=$! ; sleep 0.1s ; kill -9 $pid
        ;;
        # range is set to shutdown the computer.  when reaching 90deg or higher,
        #   this script will shutdown the computer quickly in attempt to reduce
        #   possible thermal damage to GPU.  shutdown is imediate and user will
        #   probably not see the output for this range
        9[0-9])
            echo "GPU:  $gpu2"
            echo "Status                      : GPU TEMP SHUTDOWN!! - 90c+"
            ( speaker-test -t sine -f 1000 )& pid=$! ; sleep 0.1s ; kill -9 $pid
            shutdown=true
        ;;
        *)
            echo "ERROR - \$gpu1 outside value range"
            echo "\$gpu1 = $gpu1"
            echo "\$gpu2 = $gpu2"
            ( speaker-test -t sine -f 1000 )& pid=$! ; sleep 0.1s ; kill -9 $pid
            loop=false
        ;;
    esac
    case $cpu1 in
        [0-5][0-9]|6[0-4])
            echo "CPU:  $cpu3"
        ;;
        # range is set to warn when near critical temp
        6[5-9])
            echo "CPU:  $cpu3"
            echo "Status                      : WARNING !!"
            echo "                              CPU REACHING MAXIMUM TEMP!!"
            echo "                              WILL SHUTDOWN AT 70c+"
            ( speaker-test -t sine -f 1000 )& pid=$! ; sleep 0.1s ; kill -9 $pid
        ;;
        # range is set to shutdown the computer.  when reaching critical temp,
        #   this script will shutdown the computer quickly in attempt to reduce
        #   possible thermal damage to CPU.  shutdown is imediate and user will
        #   probably not see the output for this range
        7[0-9])
            echo "CPU:  $cpu3"
            echo "Status                      : CPU TEMP SHUTDOWN!! - 70c+"
            ( speaker-test -t sine -f 1000 )& pid=$! ; sleep 0.1s ; kill -9 $pid
            shutdown=true
        ;;
        *)
            echo "ERROR - \$cpu1 outside value range"
            echo "\$cpu1 = $cpu1"
            echo "\$cpu2 = $cpu2"
            echo "\$cpu3 = $cpu3"
            ( speaker-test -t sine -f 1000 )& pid=$! ; sleep 0.1s ; kill -9 $pid
            loop=false
        ;;
    esac
    # shutdown system if true condition met
    if [ $shutdown = true ];
    then
        loop=false
        shutdown -P now
    fi
    # should loop continue
    if [ $infinate_loop = false ];
    then
        loop=false
    fi
    sleep 5
done

# exit with error code notification if any
exit $?
