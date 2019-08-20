# ros_conda_wrapper

[![Maintained](https://img.shields.io/badge/Maintained%3F-yes-green)](https://github.com/rickstaa/ros_conda_wrapper/pulse)
[![Contributions](https://img.shields.io/badge/contributions-welcome-orange.svg)](https://github.com/rickstaa/ros_conda_wrapper/blob/master/contributing.md)
[![Conda version](https://img.shields.io/badge/conda-%3D%3E4.4-blue)](https://conda.io/en/latest/)
[![Python 3](https://img.shields.io/badge/python%203-3.7%20%7C%203.6%20%7C%203.5-green.svg)](https://www.python.org/)
[![Python 2](https://img.shields.io/badge/python%202-2.7%20%7C%202.6%20%7C%202.5-green.svg)](https://www.python.org/)
[![Ros kinetic](https://img.shields.io/badge/ROS%20Kinetic-recommended-brightgreen.svg)](https://wiki.ros.org/kinetic)
[![Ros melodic](https://img.shields.io/badge/ROS%20Melodic-not%20tested-yellow.svg)](https://wiki.ros.org/melodic)

This wrapper solves some problems people have while trying to use ROS inside a conda environment.

## How to setup

1.  Add the `.conda_wrapper` file to your user home directory.
2.  Add the following code at the end of your `.bashrc`.

```bash
## Source conda wrapper script
if [ -f "~/.conda_wrapper" ]; then
    . "~/.conda_wrapper"
fi
```

## How to use

### Ros conda wrapper commands

All of the original `conda` commands work as expected. Additionally to extra commands have been added:

- `conda rosinit`: Initiates a ros_conda environment.
- `conda rosdeinit`: Removes the ros_conda initiation.

NOTE: The `conda rosinit` command doesnt create the enviroment itself it only performs some actions such that ros will work inside the conda environment.

## How it works

The `.conda_wrapper` script creates an alias which wraps the original `activate` and `deactivate` conda executable arguments. Following these wrappers fix a conflict in the [PYTHONPATH between ROS and CONDA](https://answers.ros.org/question/256886/conflict-anaconda-vs-ros-catking_pkg-not-found/). Additionally the `conda rosinit <NAME_OF_YOUR_ENVIRONMENT>` command can be used to setup a enviroment in such a way that ROS works inside the environment.

## Contributing

Contributions to this repository are welcome. See the [contribution guidelines](https://github.com/rickstaa/ros_conda_wrapper/blob/master/contributing.md) for more information.

## License

[MIT](https://github.com/rickstaa/ros_conda_wrapper/blob/master/LICENSE)
