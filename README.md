# SPI Master-Slave Interface in Verilog

This project implements an **8-bit SPI Master-Slave communication interface** in **Verilog HDL** with **full-duplex data transfer**.

## Features
- SPI Mode 0 (CPOL = 0, CPHA = 0)
- 8-bit serial data transfer
- Separate **Master** and **Slave** modules
- Full-duplex communication using:
  - **MOSI** (Master Out Slave In)
  - **MISO** (Master In Slave Out)
  - **SCLK** (Slave Clock)
  - **CS**   (Chip Select)
- Functional verification using a **testbench**
- Simulated and verified in **Xilinx Vivado**

## Files
- `spi_master.v` → SPI Master
- `spi_slave.v` → SPI Slave
- `spi_tb.v` → Testbench

## Example Result
- Master Sent: `A5`
- Slave Received: `A5`
- Slave Sent: `3C`
- Master Received: `3C`

## Tools Used
- Verilog HDL
- Xilinx Vivado
