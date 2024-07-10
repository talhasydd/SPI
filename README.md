# SPI Module Implementation in VHDL

This project implements a configurable Serial Peripheral Interface (SPI) module in VHDL, along with a comprehensive testbench for verification.

## SPI Module Features

- Supports all four SPI modes (0, 1, 2, 3)
- Configurable clock frequency
- Full-duplex operation (simultaneous transmit and receive)
- Programmable data width

## Module Architecture

The SPI module consists of the following key components:

1. Clock Generator: Creates the SPI clock based on the system clock and configured frequency.
2. Shift Register: Handles both transmit and receive operations.
3. Control Logic: Manages the SPI transaction flow, including chip select and data valid signals.
4. Mode Configuration: Sets the appropriate clock polarity and phase based on the selected SPI mode.

### Process Description

The main process in the SPI module handles both transmit and receive operations:

1. On the rising edge of the system clock:
   - If a new transmission is requested (Tx_DV asserted), load the transmit data and reset the bit counter.
   - Based on the SPI mode, sample the MISO line at the appropriate clock edge.
   - Shift out data on MOSI at the opposite clock edge.
   - Increment the bit counter and handle end-of-transmission tasks when a full byte is processed.

## Testbench

The testbench provides a comprehensive verification environment for the SPI module:

- Simulates both master and slave devices
- Verifies correct data transmission and reception
- Checks timing of control signals (chip select, data valid)
- Includes edge cases and error conditions

### Testbench Scenarios

1. Basic transmit and receive operations
2. Mode switching tests
3. Clock frequency variation tests
4. Continuous operation tests
5. Error handling (e.g., premature chip select deactivation)


## Future Improvements

- Add support for multiple slave select lines
- Implement DMA interface for high-speed data transfer
- Enhance error detection and handling capabilities
