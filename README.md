# Description

This shell script:

1. Modifies graphics settings.
2. Configures settings for dual screens.
3. Installs `xfreeRDP`.
4. Configures and generates the `xfreeRDP` connection script.

Before running this script, please ensure you have necessary permissions on the required files and folders. Always test
the script in a controlled environment before moving to production.

The script is compatible with RaspberryPi4 devices running Raspbian.

# Getting Started

## Dependencies

- Make sure you have the latest version of bash installed on your system.
- The Raspbian OS should be already installed and running on your Raspberry Pi device.
- The script should be run with root user privileges to modify system files and install packages.

## Installing

1. Download the script file from the repository.
2. Grant it execute permissions using the command: `chmod +x <your_script.sh>`.

## Executing the program

- Run the script using the command: `./<your_script.sh>`