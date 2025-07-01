# Memory Maestro: An FPGA-Powered Card Flipping Adventure 

## Welcome to the Game!

Imagine a classic memory game, but with a twist - it's running on a custom hardware platform that brings digital magic to life! This project transforms a simple card-flipping game into a high-performance embedded system adventure.

### What Makes This Special? 

- **VGA Visual Feast**: A crisp 4x4 grid that brings your memory challenge to life
- **Responsive Controls**: Navigate and flip cards with precision GPIO switches
- **Real-Time Gameplay**: Instant feedback and lightning-fast game mechanics
- **Smart Timing**: Intelligent card flip delays that keep you on your toes
- **Event Logging**: Optional UART output to track your gaming journey

### Under the Hood 

We're powering this game with some serious tech:
- **Brain**: ARM Cortex-M0 Processor
- **Nervous System**: AHB-Lite Bus Architecture
- **Memory**: Blazing-fast On-chip BRAM
- **Display**: Crystal-clear VGA Output
- **Controls**: Responsive GPIO Switches

## Project Anatomy 🗂

- `docs/`: Where the story of our project lives
- `src/rtl/`: The hardware description (our game's DNA)
- `src/testbench/`: Rigorous testing ground
- `src/software/`: Embedded software magic
- `constraints/`: FPGA connection blueprints
- `scripts/`: Build and deployment wizardry

## Let's Get Started! 

### What You'll Need
- Xilinx Vivado Design Suite (2019.1 or newer)
- Xilinx Artix-7 FPGA Board
- USB Programming Cable
- A spirit of adventure! 

### Setup in 2 Easy Steps

1. Grab the Code:
   ```bash
   git clone https://github.com/yourusername/card-flip-memory-game.git
   cd card-flip-memory-game
   ```

2. Bring It to Life:
   ```bash
   vivado -mode batch -source scripts/vivado_build.tcl
   ```

### Running Simulations
To run testbenches, use the following Vivado commands:
```bash
# VGA Display Testbench
xvlog src/testbench/vga_display_tb.v
xelab vga_display_tb
xsim vga_display_tb

# Game Logic Testbench
xvlog src/testbench/game_logic_tb.v
xelab game_logic_tb
xsim game_logic_tb

# UART Logger Testbench
xvlog src/testbench/uart_logger_tb.v
xelab uart_logger_tb
xsim uart_logger_tb
```

### UART Logging
The game includes an optional UART logging module that transmits game events:
- Card flipped events
- Card match events
- Game completion events (with total moves)

To view UART logs:
1. Connect a USB-to-UART converter to the UART TX pin
2. Use a terminal program (e.g., PuTTY, screen) with:
   - Baud Rate: 115200
   - Data Bits: 8
   - Stop Bits: 1
   - Parity: None

### Hardware Connections

#### GPIO Switches
- `UP_BTN`: Navigate cursor up
- `DOWN_BTN`: Navigate cursor down
- `LEFT_BTN`: Navigate cursor left
- `RIGHT_BTN`: Navigate cursor right
- `SELECT_BTN`: Select/Flip card

#### VGA Output
- `HSYNC`: Horizontal sync
- `VSYNC`: Vertical sync
- `RED[3:0]`: Red color channel
- `GREEN[3:0]`: Green color channel
- `BLUE[3:0]`: Blue color channel

#### 7-Segment Display
- `SEG_DISPLAY[6:0]`: Segment lines
- `SEG_SELECT[3:0]`: Digit selection

#### UART
- `UART_TX`: Transmit line for game event logging

### Bitstream Generation
The build script automatically generates a bitstream in the `build/` directory.

### Programming the FPGA
1. Open Vivado Hardware Manager
2. Connect your FPGA board
3. Open the generated bitstream
4. Program the device

## Hardware Connections

### Detailed Pin and Interface Mapping

#### Cortex-M0 Processor Connections
- `HCLK`: System Clock Input
- `HRESETn`: Active-Low Reset
- `HADDR[31:0]`: Address Bus
- `HWDATA[31:0]`: Write Data Bus
- `HRDATA[31:0]`: Read Data Bus
- `HWRITE`: Read/Write Control
- `HSIZE`: Transfer Size
- `HTRANS`: Transfer Type
- `HREADY`: Bus Ready Signal
- `HRESP`: Transfer Response

#### VGA Display Interface
- `VSYNC`: Vertical Sync Signal
- `HSYNC`: Horizontal Sync Signal
- `RED[3:0]`: Red Color Channel
- `GREEN[3:0]`: Green Color Channel
- `BLUE[3:0]`: Blue Color Channel

#### GPIO Switch Connections
- `UP_SWITCH`: Navigate Cursor Up
- `DOWN_SWITCH`: Navigate Cursor Down
- `LEFT_SWITCH`: Navigate Cursor Left
- `RIGHT_SWITCH`: Navigate Cursor Right
- `SELECT_SWITCH`: Select/Flip Card

#### 7-Segment Display
- `SEG_DISPLAY[6:0]`: Segment Lines
- `SEG_SELECT[3:0]`: Digit Selection Lines

#### UART Interface
- `UART_TX`: Transmit Line for Game Event Logging

### Hardware Connection Diagram

```
                   +-------------------+
                   |  Cortex-M0 SoC    |
                   |                   |
    +------------->|  AHB-Lite Bus     |<------------+
    |              |                   |             |
    |              +-------------------+             |
    |                     |                          |
    |                     |                          |
    |              +------v------+           +-------v------+
    |              |  Game Logic |           |   Timer      |
    |              |  Controller |           |   Module     |
    |              +------+------+           +-------+------+
    |                     |                          |
    |                     |                          |
+---v------+        +-----v------+           +-------v------+
| GPIO     |        | VGA Display|           | 7-Segment    |
| Switches |        | Module     |           | Display      |
+---+------+        +-----+------+           +-------+------+
    |                     |                          |
    +---------------------+                          |
                                                     |
                                                     v
```

#### Detailed Interconnection Notes
1. The Cortex-M0 processor manages all module interactions via the AHB-Lite bus
2. Game logic controller coordinates game state and module interactions
3. GPIO switches provide player input
4. VGA display renders game state visually
5. Timer module manages card flip delays
6. 7-segment display shows game statistics
7. UART logger transmits game events externally

## License

MIT License

Copyright (c) 2025 Shashank Cuppala

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

## Contributors
Shashank Cuppala
