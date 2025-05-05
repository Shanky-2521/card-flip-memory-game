`timescale 1ns/1ps

module game_logic_tb();
    // Inputs
    reg clk;
    reg reset;
    reg up_btn;
    reg down_btn;
    reg left_btn;
    reg right_btn;
    reg select_btn;

    // Outputs
    wire [3:0] cursor_pos;
    wire [15:0] card_values;
    wire [15:0] card_states;
    wire [7:0] move_count;
    wire game_won;

    // Instantiate the Unit Under Test (UUT)
    game_logic uut (
        .clk(clk),
        .reset(reset),
        .up_btn(up_btn),
        .down_btn(down_btn),
        .left_btn(left_btn),
        .right_btn(right_btn),
        .select_btn(select_btn),
        .cursor_pos(cursor_pos),
        .card_values(card_values),
        .card_states(card_states),
        .move_count(move_count),
        .game_won(game_won)
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
        up_btn = 0;
        down_btn = 0;
        left_btn = 0;
        right_btn = 0;
        select_btn = 0;

        // Wait for global reset
        #100;
        reset = 0;

        // Test cursor movement
        #10 up_btn = 1;
        #10 up_btn = 0;
        #10 right_btn = 1;
        #10 right_btn = 0;

        // Test card selection
        #10 select_btn = 1;
        #10 select_btn = 0;

        // Move to another card
        #10 right_btn = 1;
        #10 right_btn = 0;
        #10 down_btn = 1;
        #10 down_btn = 0;

        // Select second card
        #10 select_btn = 1;
        #10 select_btn = 0;

        // Simulate multiple moves
        repeat(10) begin
            #20 {up_btn, down_btn, left_btn, right_btn} = $random;
            #10 select_btn = $random;
        end

        // Run for a while
        #1000;

        // Finish simulation
        $finish;
    end

    // Optional: Waveform dumping
    initial begin
        $dumpfile("game_logic_tb.vcd");
        $dumpvars(0, game_logic_tb);
    end
endmodule
