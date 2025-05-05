module timer_module (
    input wire clk,           // System clock
    input wire reset,         // Active-high reset
    input wire start_timer,   // Trigger to start the timer
    input wire [15:0] delay,  // Delay duration in clock cycles
    
    output reg timer_done     // Timer completion flag
);

    // Timer state machine
    reg [15:0] timer_count;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset timer state
            timer_count <= 16'h0000;
            timer_done <= 1'b0;
        end else begin
            // Timer logic
            if (start_timer) begin
                // Start counting
                if (timer_count < delay) begin
                    timer_count <= timer_count + 1;
                    timer_done <= 1'b0;
                end else begin
                    // Timer completed
                    timer_count <= 16'h0000;
                    timer_done <= 1'b1;
                end
            end else begin
                // Reset timer when not active
                timer_count <= 16'h0000;
                timer_done <= 1'b0;
            end
        end
    end

endmodule
