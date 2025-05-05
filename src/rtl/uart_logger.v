module uart_logger (
    input wire clk,               // System clock
    input wire reset,             // Active-high reset
    
    // Game event inputs
    input wire [3:0] card_pos,    // Position of flipped card
    input wire card_flipped,      // Card flipped event
    input wire card_matched,      // Card match event
    input wire game_won,          // Game completion event
    input wire [7:0] move_count,  // Current move count
    
    // UART TX line
    output reg uart_tx,           // UART transmit line
    output wire tx_done           // Transmission complete flag
);

    // UART transmission parameters
    localparam BAUD_RATE = 115200;
    localparam CLOCK_FREQ = 100_000_000;  // 100 MHz
    localparam BAUD_DIV = CLOCK_FREQ / BAUD_RATE;

    // State machine for UART transmission
    reg [3:0] tx_state;
    reg [7:0] tx_data;
    reg [15:0] baud_counter;
    reg [3:0] bit_count;

    // Transmission states
    localparam IDLE = 4'b0000;
    localparam START = 4'b0001;
    localparam DATA = 4'b0010;
    localparam STOP = 4'b0011;

    // Event logging logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset all signals
            uart_tx <= 1'b1;  // Idle high
            tx_state <= IDLE;
            tx_data <= 8'h00;
            baud_counter <= 16'h0000;
            bit_count <= 4'h0;
        end else begin
            // UART transmission state machine
            case (tx_state)
                IDLE: begin
                    uart_tx <= 1'b1;  // Idle high
                    
                    // Log game events
                    if (card_flipped) begin
                        tx_data <= {4'h0, card_pos};  // Card position
                        tx_state <= START;
                    end else if (card_matched) begin
                        tx_data <= 8'hAA;  // Match event
                        tx_state <= START;
                    end else if (game_won) begin
                        tx_data <= move_count;  // Moves to win
                        tx_state <= START;
                    end
                end

                START: begin
                    // Start bit (low)
                    uart_tx <= 1'b0;
                    bit_count <= 4'h0;
                    
                    // Baud rate generation
                    if (baud_counter < BAUD_DIV) begin
                        baud_counter <= baud_counter + 1;
                    end else begin
                        baud_counter <= 16'h0000;
                        tx_state <= DATA;
                    end
                end

                DATA: begin
                    // Transmit data bits
                    uart_tx <= tx_data[bit_count];
                    
                    if (baud_counter < BAUD_DIV) begin
                        baud_counter <= baud_counter + 1;
                    end else begin
                        baud_counter <= 16'h0000;
                        
                        if (bit_count < 4'd7) begin
                            bit_count <= bit_count + 1;
                        end else begin
                            tx_state <= STOP;
                        end
                    end
                end

                STOP: begin
                    // Stop bit (high)
                    uart_tx <= 1'b1;
                    
                    if (baud_counter < BAUD_DIV) begin
                        baud_counter <= baud_counter + 1;
                    end else begin
                        baud_counter <= 16'h0000;
                        tx_state <= IDLE;
                    end
                end

                default: tx_state <= IDLE;
            endcase
        end
    end

    // Transmission complete flag
    assign tx_done = (tx_state == IDLE);

endmodule
