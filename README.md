<p align="center">
  <img src="https://i.imgur.com/epw8sfM.png"/>
</p>

# RISC-DCCCLXVII
A RISC-V-like CPU designed in SystemVerilog for a Hardware Infrastructure class.

## Compiling and running
In the `config` folder there are three scripts that can be used to automatically compile the files:  
* `initsim.sh` will set the correct PATH for your directory, setup and launch ModelSim with all the right configs. 
* `comp_hdl.sh` will compile only the files in the `hdl` folder.  
* `comp_bench.sh` will compile all testbench files.

There are two ways to use the included build scripts. First, give all compile scripts executable permission:

```zsh
sudo chmod +x config/*.sh
```

### Using VSCode

On VSCode, run the default build task with <kbd>CTRL</kbd> + <kbd>SHIFT</kbd> + <kbd>B</kbd>. It should also provide problem matching for all files.

### Using the terminal

Change `PATH_WORK=$(pwd)` to `PATH_WORK=$(cd ..; pwd)` in `config/comp_bench.sh` and `config/comp_hdl.sh` using a text editor.

Run the scripts.

### Running
Once you've compiled the files, run `cd config; source initsim.sh` on a terminal, or run the `Run ModelSim` task on VSCode. It should automatically launch and configure the simulation, provided you have ModelSim correctly setup on your PATH.

## Folder structure
* `bench`: all testbench files
* `config`: scripts for running/compilation
* `docs`: diagrams and state machine visualizations
* `hdl`: all module files
  * `hdl/memory`: memory modules

## Coding guidelines

* 4 space identation
* `snake_case` naming for all variables
* Don't specify `in_` or `out_` in signal names outside of module declarations.
```verilog
« DON'T »             « DO »
                    
                      module foo(
                        input wire i_signal
wire i_signal;        );
```
* Explicit `.` operator when using modules
* Clock is always `clk`, reset is always `reset`
* Always use `enums` instead of arbitrary binary values in state machines/selector pins
```verilog
« DON'T »             « DO »

always @(*)           enum {READ, WAIT} states;
  case (foo)          always @(*)
    2'b00: ..           case (foo)
    2'b01: ..             READ: ..
    2'b11: ..             WAIT: ..
```

* Write the datatype for *all* variables. Only one declaration *per line*. Don't use implicit declaration.
