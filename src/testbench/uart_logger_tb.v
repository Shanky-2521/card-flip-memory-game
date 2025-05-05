`timescale 1ns/1ps

module uart_logger_tb();
    // Inputs
    reg clk;
    reg reset;
    reg [3:0] card_pos;
    reg card_flipped;
    reg card_matched;
    reg game_won;
    reg [7:0] move_count;

    // Outputs
    wire uart_tx;
    wire tx_done;

    // Instantiate the Unit Under Test (UUT)
    uart_logger uut (
        .clk(clk),
        .reset(reset),
        .card_pos(card_pos),
        .card_flipped(card_flipped),
        .card_matched(card_matched),
        .game_won(game_won),
        .move_count(move_count),
        .uart_tx(uart_tx),
        .tx_done(tx_done)
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
        card_pos = 4'h0;
        card_flipped = 0;
        card_matched = 0;
        game_won = 0;
        move_count = 8'h00;

        // Wait for global reset
        #100;
        reset = 0;

        // Test card flipped event
        #10 card_pos = 4'h5;
        #10 card_flipped = 1;
        #10 card_flipped = 0;

        // Test card matched event
        #100 card_matched = 1;
        #10 card_matched = 0;

        // Test game won event
        #100 game_won = 1;
        move_count = 8'h0A;  // 10 moves
        #10 game_won = 0;

        // Run for a while to see UART transmission
        #1000;

        // Finish simulation
        $finish;
    end

    // Optional: Waveform dumping
    initial begin
        $dumpfile("uart_logger_tb.vcd");
        $dumpvars(0, uart_logger_tb);
    end

    // Optional: Monitor UART TX
    initial begin
        $monitor("Time=%0t reset=%b card_pos=%h card_flipped=%b card_matched=%b game_won=%b move_count=%h uart_tx=%b", 
                  $time, reset, card_pos, card_flipped, card_matched, game_won, move_count, uart_tx);
    end
endmodule
