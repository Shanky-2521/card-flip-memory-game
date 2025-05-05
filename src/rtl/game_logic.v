module game_logic (
    input wire clk,               // System clock
    input wire reset,             // Active-high reset
    
    // Player inputs
    input wire up_btn,            // Up navigation button
    input wire down_btn,          // Down navigation button
    input wire left_btn,          // Left navigation button
    input wire right_btn,         // Right navigation button
    input wire select_btn,        // Card selection button
    
    // Game state outputs
    output reg [3:0] cursor_pos,  // Current cursor position
    output reg [15:0] card_values,// Values of cards (4x4 grid)
    output reg [15:0] card_states,// States of cards (4x4 grid)
    output reg [7:0] move_count,  // Number of moves made
    output reg game_won           // Game completion flag
);

    // Card states encoding
    localparam CARD_HIDDEN   = 2'b00;
    localparam CARD_FLIPPED  = 2'b01;
    localparam CARD_MATCHED  = 2'b10;

    // Game state variables
    reg [3:0] first_card_pos;
    reg first_card_selected;
    reg [3:0] selected_cards_count;

    // Initialization and Game Logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset game state
            cursor_pos <= 4'b0000;
            card_states <= 16'h0000;
            card_values <= 16'h0000;
            move_count <= 8'h00;
            game_won <= 1'b0;
            first_card_selected <= 1'b0;
            selected_cards_count <= 4'h0;
            
            // Randomize card values (simplified)
            card_values <= 16'b0101_0101_1010_1010;
        end else begin
            // Navigation logic
            if (up_btn && cursor_pos[3:2] > 0)
                cursor_pos[3:2] <= cursor_pos[3:2] - 1;
            else if (down_btn && cursor_pos[3:2] < 3)
                cursor_pos[3:2] <= cursor_pos[3:2] + 1;
            else if (left_btn && cursor_pos[1:0] > 0)
                cursor_pos[1:0] <= cursor_pos[1:0] - 1;
            else if (right_btn && cursor_pos[1:0] < 3)
                cursor_pos[1:0] <= cursor_pos[1:0] + 1;
            
            // Card selection logic
            if (select_btn) begin
                // First card selection
                if (!first_card_selected) begin
                    if (card_states[cursor_pos] == CARD_HIDDEN) begin
                        card_states[cursor_pos] <= CARD_FLIPPED;
                        first_card_pos <= cursor_pos;
                        first_card_selected <= 1'b1;
                        selected_cards_count <= selected_cards_count + 1;
                    end
                end
                // Second card selection
                else begin
                    if (card_states[cursor_pos] == CARD_HIDDEN && cursor_pos != first_card_pos) begin
                        card_states[cursor_pos] <= CARD_FLIPPED;
                        selected_cards_count <= selected_cards_count + 1;
                        move_count <= move_count + 1;
                        
                        // Check for match
                        if (card_values[first_card_pos] == card_values[cursor_pos]) begin
                            card_states[first_card_pos] <= CARD_MATCHED;
                            card_states[cursor_pos] <= CARD_MATCHED;
                        end
                        
                        // Reset for next turn
                        first_card_selected <= 1'b0;
                    end
                end
            end
            
            // Check for game completion
            if (&card_states[15:0]) begin
                game_won <= 1'b1;
            end
        end
    end

endmodule
