# Slint MCU C++ Template for STM32H735G-DK boards

A template for a C++ application running on an [STM32H735G-DK Discovery kit](https://www.st.com/en/evaluation-tools/stm32h735g-dk.html) that's using [Slint](https://slint.dev) for the user interface, CMake for the build system.

## About

This template helps you get started developing a C++ application with Slint as toolkit
for the user interface. It demonstrates the integration between the `.slint` UI markup and
C++ code, how to trigger react to callbacks, get and set properties and use basic widgets.

## Prerequisites

In order to use this template and build a C++ application, you need to install a few tools:

  * **[cmake](https://cmake.org/download/)** (3.21 or newer)
  * **[STM32CubeCLT](https://www.st.com/en/development-tools/stm32cubeclt.html)**
  * **[Visual Studio Code](https://code.visualstudio.com)**
  * **[Slint extension](https://marketplace.visualstudio.com/items?itemName=Slint.slint)**
  * **[STM32 VS Code Extension](https://marketplace.visualstudio.com/items?itemName=stmicroelectronics.stm32-vscode-extension)**
  * **[CMake Tools](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cmake-tools)**

## Usage

1. Open this folder with VS code.
2. Configure the project either via "CMake: Select Configure Preset" from the command palette or the CMake extension panel.
3. Build, Flash to Device, and debug by hitting `F5` or running the `CMake: Debug` command from the command palette.

## Next Steps

We hope that this template helps you get started and you enjoy exploring making user interfaces with Slint. To learn more
about the Slint APIs and the `.slint` markup language check out our [online documentation](https://slint.dev/docs/cpp/).

Don't forget to edit this README to replace it by yours.
