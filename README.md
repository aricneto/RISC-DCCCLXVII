<p align="center">
  <img src="https://i.imgur.com/epw8sfM.png"/>
</p>

# RISC-DCCCLXVII
A RISC-V-like CPU designed in SystemVerilog for a Hardware Infrastructure class.

## Compiling and running
In the `config` folder there are three scripts that can be used to automatically compile the files:  
* `cfgpath.sh` will set the correct PATH for your directory. You should run `source cfgpath.sh` before running any other scripts so ModelSim will recognize your work folders . 
* `comp_hdl.sh` will compile only the files in the `hdl` folder.  
* `comp_bench.sh` will compile all testbench files.

There are two ways to use the included build scripts.
### Using VSCode
Go to `config` folder:

```zsh
cd config
``` 

Give all compile scripts executable permission:

```zsh
sudo chmod +x comp_*.sh
```

On VSCode, run the default build task with <kbd>CTRL</kbd> + <kbd>SHIFT</kbd> + <kbd>B</kbd>. It should also provide problem matching for all files.
### Using the terminal
Go to config folder:

```zsh
cd config
``` 

Change `PATH_WORK=$(pwd)` to `PATH_WORK=$(cd ..; pwd)` in `comp_bench.sh` and `comp_hdl.sh` using a text editor.

Give all compile scripts executable permission:

```zsh
sudo chmod +x comp_*.sh
```
Run the scripts.

### Running
Once you've compiled the files, open ModelSim `vsim &` (assuming it's in your path), select a file and run the simulation.

## Folder structure
* `bench`: all testbench files
* `hdl`: all module files
  * `hdl/memory`: memory modules
* `config`: scripts for running/compilation

## Coding guidelines

* 4 space identation
* `snake_case` naming for all variables
* Don't specify `in_` or `out_` in variable names
* Explicit `.` operator when using modules
* Clock is always `clk`, reset is always `reset`
* Always use `enums` instead of arbitrary binary values in state machines/selector pins
```verilog
« DON'T »

always @(*)
  case (foo)
    2'b00: ..
    2'b01: ..
    2'b11: ..
```

```verilog
« DO »

enum {READ, WAIT, WALK} states;
always @(*)
  case (foo)
    READ: ..
    WAIT: ..
    WALK: ..
```
* Write the datatype for *all* variables. Only one declaration *per line*. Don't use implicit declaration:
```verilog
« DON'T »

input logic a, b, c;
```
```verilog
« DO »

input logic a;
input logic b;
input logic c;
```
This makes it easier to search, change, and identify the type of each variable.
