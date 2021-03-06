# nvidia-gpu-temp-monitor
A linux bash script to monitor Nvidia gpu temperature, and shutdown if temperature reaches critical.

 about:
   nvtempmon.sh is written to run as a bash-script specifically for the
       Nvidia GTX1060 graphics card driver.  other graphics cards may
       have different commands or temp thresholds.  the intention is
       to display gpu and cpu temps in a simple to read format, and
       will allow continous monitoring of gpu temperature and
       automatically shutdown the computer if gpu temperatures near
       the max specified.  warnings will be visual text in the
       terminal window; and if able, audio through attached speakers.
 directions:
   installation:
       1.  download file and place nvtempmon.sh with other command scripts or
            directory.
            e.g. /usr/local/bin/     (recomended)
            e.g. /home/user/Desktop/
            e.g. ~/Downloads
       2.  make the file executable (use gui or chmod from terminal).
            e.g.     user@computer $:  sudo chmod +x /usr/local/bin/nvtempmon.sh
   execution:
       1.  open a terminal window, navigate to file if needed, and run.
            e.g.     user@computer $:  nvtempmon.sh
                          (if stored in - /usr/local/bin/)
                     user@computer $:  ./NvTempMon.sh
                          (if in same directory of file)
                     user@computer $:  /usr/local/bin/NvTempMon.sh
                          (use full path from anywhere)
   use:
       if using a linux gui, the terminal window can be resized or
            minimized depending on preference.  if the Nvidia gpu
            reaches above 85deg, the computer will display a text
            warning, and attempt to beep through the speakers.  if
            the gpu reaches above 90deg, the computer will attempt
            to shutdown in order to avoid thermal dammage to the gpu.
   troubleshooting:
       i have the code in the file, but it will not run?
            make sure the file is executable.  you can do this by using
                 'chmod' on the file.
                 e.g.  user@computer $:  chmod +x NvTempMon.sh

 dependencies:
   nvidia-smi  -   command included with nvidia driver
   to verify, try running 'nvidia-smi' from the terminal.  if properly
       installed on your system, you will receive output.  for
       'nvidia-smi' support, please check with the driver provider.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
   EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
   MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
   IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR
   ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
   CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
   WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. 

 bug reports or requests:
   please submit to https://www.github/zagard/nvidia-gpu-temp-monitor/
######################################################################
