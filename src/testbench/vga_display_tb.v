`timescale 1ns/1ps

module vga_display_tb();
    // Inputs
    reg clk;
    reg reset;
    reg [3:0] card_states;
    reg [3:0] cursor_pos;

    // Outputs
    wire hsync;
    wire vsync;
    wire [3:0] red;
    wire [3:0] green;
    wire [3:0] blue;

    // Instantiate the Unit Under Test (UUT)
    vga_display uut (
        .clk(clk),
        .reset(reset),
        .card_states(card_states),
        .cursor_pos(cursor_pos),
        .hsync(hsync),
        .vsync(vsync),
        .red(red),
        .green(green),
        .blue(blue)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 100 MHz clock
    end

    // Test sequence
    initial begin
        // Initialize inputs
        reset = 1;
        card_states = 4'b0000;
        cursor_pos = 4'b0000;

        // Wait for global reset
        #100;
        reset = 0;

        // Test different card states and cursor positions
        #10 card_states = 4'b0101;  // Some cards flipped
        #10 cursor_pos = 4'b0011;   // Move cursor

        #10 card_states = 4'b1010;  // Some cards matched
        #10 cursor_pos = 4'b1100;   // Move cursor again

        // Run for a while to see VGA signals
        #1000;

        // Finish simulation
        $finish;
    end

    // Optional: Waveform dumping
    initial begin
        $dumpfile("vga_display_tb.vcd");
        $dumpvars(0, vga_display_tb);
    end
endmodule
