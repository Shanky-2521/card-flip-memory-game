module card_flip_game_top (
    input wire clk,           // System clock
    input wire reset,         // Active-high reset
    
    // GPIO Switches
    input wire up_btn,
    input wire down_btn,
    input wire left_btn,
    input wire right_btn,
    input wire select_btn,
    
    // VGA Output
    output wire hsync,
    output wire vsync,
    output wire [3:0] red,
    output wire [3:0] green,
    output wire [3:0] blue,
    
    // Optional 7-Segment Display
    output wire [6:0] seg_display,
    output wire [3:0] seg_select,
    
    // UART Logger Output
    output wire uart_tx
);

    // Internal signals
    wire [3:0] cursor_pos;
    wire [15:0] card_values;
    wire [15:0] card_states;
    wire [7:0] move_count;
    wire game_won;
    
    // Timer signals
    wire start_timer;
    wire timer_done;
    
    // Game Logic Module
    game_logic game_controller (
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
    
    // VGA Display Module
    vga_display display (
        .clk(clk),
        .reset(reset),
        .card_states(card_states[3:0]),
        .cursor_pos(cursor_pos),
        .hsync(hsync),
        .vsync(vsync),
        .red(red),
        .green(green),
        .blue(blue)
    );
    
    // Timer Module
    timer_module game_timer (
        .clk(clk),
        .reset(reset),
        .start_timer(start_timer),
        .delay(16'd50000),  // Configurable delay
        .timer_done(timer_done)
    );
    
    // Optional 7-Segment Display Driver (Placeholder)
    seven_segment_driver seg_driver (
        .clk(clk),
        .reset(reset),
        .move_count(move_count),
        .game_won(game_won),
        .seg_display(seg_display),
        .seg_select(seg_select)
    );

    // UART Logger Module
    uart_logger game_logger (
        .clk(clk),
        .reset(reset),
        .card_pos(cursor_pos),
        .card_flipped(select_btn),
        .card_matched(game_controller.card_matched),
        .game_won(game_won),
        .move_count(move_count),
        .uart_tx(uart_tx)
    );

endmodule

// 7-Segment Display Driver (Basic Implementation)
module seven_segment_driver (
    input wire clk,
    input wire reset,
    input wire [7:0] move_count,
    input wire game_won,
    output reg [6:0] seg_display,
    output reg [3:0] seg_select
);
    // Basic 7-segment display logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            seg_display <= 7'b1111111;  // All segments off
            seg_select <= 4'b1110;      // Select first digit
        end else begin
            if (game_won) begin
                // Display "WIN" 
                seg_display <= 7'b0010101;
            end else begin
                // Display move count
                case (move_count[3:0])
                    4'h0: seg_display <= 7'b1000000; // 0
                    4'h1: seg_display <= 7'b1111001; // 1
                    4'h2: seg_display <= 7'b0100100; // 2
                    4'h3: seg_display <= 7'b0110000; // 3
                    4'h4: seg_display <= 7'b0011001; // 4
                    4'h5: seg_display <= 7'b0010010; // 5
                    4'h6: seg_display <= 7'b0000010; // 6
                    4'h7: seg_display <= 7'b1111000; // 7
                    4'h8: seg_display <= 7'b0000000; // 8
                    4'h9: seg_display <= 7'b0010000; // 9
                    default: seg_display <= 7'b1111111; // Off
                endcase
            end
        end
    end
endmodule
