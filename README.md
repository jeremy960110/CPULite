# CPU_Lite

A lightweight CPU design project implemented in Verilog.

## Project Structure

- **alu.v** - Arithmetic Logic Unit
- **cpu16_core.v** - Core CPU architecture
- **regfile.v** - Register File
- **imem.v** - Instruction Memory
- **instruction_rom.v** - Instruction ROM
- **top_mif.v** - Top-level module with MIF file support

## Files

- `program.mif` - Program memory initialization file
- `*.qpf`, `*.qsf` - Quartus project files
- `db/` - Quartus database files
- `output_files/` - Generated output files
- `simulation/` - Simulation files

## Getting Started

This project uses Quartus for synthesis and simulation. The Verilog modules can be simulated using testbenches (e.g., `top_mif_tb.v`).

## Repository

[CPULite on GitHub](https://github.com/jeremy960110/CPULite.git)
