# Collection of small FPGA starter projects for the Lattice ICE 40HX1K


## List of projects
1. Pulsing LED

## Install build tools

```
chmod +x install_ice40_toolchain_mac.sh
./install_ice40_toolchain_mac.sh
```

## To build and load instructions to the board:

1. **Write Verilog Code**
   - Create your design in a `.v` file
   ```
   nano blinky.v
   ```

2. **Synthesize Design**
   - Run synthesis tool (Yosys)
   ```
   yosys -p "synth_ice40 -top module_name -json output.json" input.v
   ```

3. **Create Constraints File**
   - Define pin mappings in a `.pcf` file
   ```
   nano pinout.pcf
   ```

4. **Place and Route**
   - Run place and route tool (nextpnr)
   ```
   nextpnr-ice40 --hx1k --package vq100 --json input.json --pcf pinout.pcf --asc output.asc
   ```

5. **Generate Bitstream**
   - Convert ASCII to binary bitstream
   ```
   icepack output.asc output.bin
   ```

6. **Upload to FPGA**
   - Connect FPGA board
   - Use upload tool to program FPGA with bitstream
   ```
   iceprog output.bin
   ```

7. **Verify**
   - Check if design works as expected on FPGA

Notes:
- Replace `module_name`, `input.v`, `output.json`, etc., with your actual file names.
- The `--hx1k --package vq100` options in the nextpnr command are specific to the iCE40-HX1K in a VQ100 package. Adjust these for your specific FPGA model.
- Ensure all necessary tools (Yosys, nextpnr, icestorm) are installed and in your system PATH.