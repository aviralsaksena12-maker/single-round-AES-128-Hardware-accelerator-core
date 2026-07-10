# Single-Round AES-128 Hardware Accelerator

A Verilog HDL implementation of a single AES-128 encryption round, built as a combinational hardware pipeline covering **SubBytes**, **ShiftRows**, **MixColumns**, and **AddRoundKey**. Includes a Vivado VIO-based interactive test harness for on-hardware verification alongside a standard testbench for simulation.

---

## Overview

This project implements one AES-128 round as a fully combinational datapath:

* **SubBytes** (`sbox_lookup.v`) — 16 parallel S-Box instances performing byte substitution.
* **ShiftRows** — Row-wise cyclic left shift of the state matrix, implemented as pure wiring (no logic).
* **MixColumns** — Column mixing operation.
* **AddRoundKey** — Final XOR of the mixed state with the round key.

The design is verified in simulation using a testbench (`tb_aes.v`) and can also be exercised live on hardware through a VIO (Virtual I/O) wrapper (`aes_vio_top.v`), allowing state and key inputs to be driven and the output observed directly through Vivado's hardware manager without needing external I/O pins.

---

## Repository Structure

```text
.
├── aes_single_round.v    # Top-level round module
├── sbox_lookup.v         # S-Box byte substitution module
├── aes_vio_top.v         # Vivado VIO wrapper for interactive hardware testing
├── tb_aes.v              # Testbench for simulation
└── README.md

```

---

## Module Details

### `aes_single_round.v`

Top-level module. Takes a 128-bit state and 128-bit round key, produces a 128-bit output after passing through all four AES transformations combinationally (no clock, no registers).

### `sbox_lookup.v`

Performs byte substitution via a case-statement lookup.

> **Note:** The current table only defines entries for `0x00–0x05`; all other byte values fall through to a placeholder scramble (`byte_in ^ 0x99`) rather than the full AES S-Box. This needs the complete 256-entry S-Box table filled in before results will match standard AES output.

### `ShiftRows` (Inline)

Pure bit-wiring — rotates each row of the state matrix by 0/1/2/3 bytes respectively. No gates involved.

### `MixColumns` (Inline)

> **Note:** Currently implemented as a simplified XOR-based mix (`shift_rows_out ^ rotated(shift_rows_out)`) rather than true $GF(2^8)$ matrix multiplication used in the AES standard. This is a placeholder for the real MixColumns transform.

### `aes_vio_top.v`

Wraps the AES core with a Xilinx VIO (Virtual Input/Output) IP core, letting you drive `state_in` and `round_key` and observe `state_out` live through Vivado's Hardware Manager.

* **Requirement:** Requires a VIO IP instance (`vio_0`) generated in your Vivado project with matching probe widths (two 128-bit probe outputs, one 128-bit probe input).

### `tb_aes.v`

Simulation testbench. Applies a fixed 128-bit state and round key, waits for the combinational logic to settle, and displays input/output via `$display`.
