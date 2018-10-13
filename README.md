<p align="center">
  <img src="https://i.imgur.com/epw8sfM.png"/>
</p>

# RISC-DCCCLXVII
A RISC-V-like CPU designed in SystemVerilog for a Hardware Infrastructure class.

## Compiling and running
In the `config` folder there are three `.do` files that can be used to compile and run the project in any operating system:
* `initsim.do` will compile and run the simulation.
* `compile.do` will compile all files.
* `waves.do` will setup all the waves for the simulation.

Addidionaly, if you're in a Linux system, `initsim.sh` will set the correct PATH for your directory, setup and launch ModelSim with all the right configs. 

There are two ways to use the included build scripts.

### Using ModelSim

Open ModelSim. On the `File` menu, choose `Change directory`.  
Open the root folder of the project. On the transcript window, type
```
do config/initsim.do
```
It should then compile and setup the simulation automatically.

### Using VSCode on Linux

First, make sure ModelSim is in your PATH. Then, give all compile scripts executable permission:

```zsh
sudo chmod +x config/*.do ; sudo chmod +x config/sh/initsim.sh
```

In VSCode, open the task menu with <kbd>CTRL</kbd> + <kbd>ALT</kbd> + <kbd>B</kbd>. Run `Compile TOP` first to compile all files, then run `Run ModelSim` to setup the simulation environment.

## Folder structure
* `bench`: all testbench files
* `config`: scripts for running/compilation
* `docs`: diagrams and state machine visualizations
* `hdl`: all module files
  * `hdl/memory`: memory modules
  * `hdl/packages`: functions and constants
* `libs`: build folder
* `mem`: stores memory instructions for pre-load

## Coding guidelines

* 4 space identation
* `snake_case` naming for all variables
* Don't specify `in_` or `out_` in signal names outside of module declarations.
```verilog
« DON'T »             « DO »
                    
wire i_signal;        module foo(
                        input wire i_signal
                      );
```
* Explicit `.` operator when using modules
* Clock is always `clk`, reset is always `reset`
* Always use `enums` instead of arbitrary binary values in state machines/selector pins
```verilog
« DON'T »             « DO »

always_comb           enum {READ, WAIT} states;
  case (foo)          always_comb
    2'b00: ..           case (foo)
    2'b01: ..             READ: ..
    2'b11: ..             WAIT: ..
```

* Write the datatype for *all* variables. Only one declaration *per line*. Don't use implicit declaration.
