module vga_display (
    input wire clk,              // System clock
    input wire reset,             // Active-high reset
    input wire [3:0] card_states, // State of each card (4x4 grid)
    input wire [3:0] cursor_pos,  // Current cursor position
    
    // VGA output signals
    output wire hsync,            // Horizontal sync
    output wire vsync,            // Vertical sync
    output wire [3:0] red,        // Red color channel
    output wire [3:0] green,      // Green color channel
    output wire [3:0] blue        // Blue color channel
);

    // VGA timing parameters (for 640x480 @ 60Hz)
    localparam H_ACTIVE = 640;
    localparam H_FRONT_PORCH = 16;
    localparam H_SYNC = 96;
    localparam H_BACK_PORCH = 48;
    localparam V_ACTIVE = 480;
    localparam V_FRONT_PORCH = 10;
    localparam V_SYNC = 2;
    localparam V_BACK_PORCH = 33;

    // Internal signals
    reg [9:0] h_count;  // Horizontal pixel counter
    reg [9:0] v_count;  // Vertical line counter
    reg video_on;       // Active video region flag

    // Horizontal and Vertical Sync Generation
    assign hsync = (h_count >= (H_ACTIVE + H_FRONT_PORCH)) && 
                   (h_count < (H_ACTIVE + H_FRONT_PORCH + H_SYNC));
    assign vsync = (v_count >= (V_ACTIVE + V_FRONT_PORCH)) && 
                   (v_count < (V_ACTIVE + V_FRONT_PORCH + V_SYNC));

    // Horizontal Counter
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            h_count <= 0;
        end else begin
            if (h_count < (H_ACTIVE + H_FRONT_PORCH + H_SYNC + H_BACK_PORCH - 1)) begin
                h_count <= h_count + 1;
            end else begin
                h_count <= 0;
            end
        end
    end

    // Vertical Counter
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            v_count <= 0;
        end else begin
            if (h_count == (H_ACTIVE + H_FRONT_PORCH + H_SYNC + H_BACK_PORCH - 1)) begin
                if (v_count < (V_ACTIVE + V_FRONT_PORCH + V_SYNC + V_BACK_PORCH - 1)) begin
                    v_count <= v_count + 1;
                end else begin
                    v_count <= 0;
                end
            end
        end
    end

    // Video On Region
    always @(posedge clk) begin
        video_on <= (h_count < H_ACTIVE) && (v_count < V_ACTIVE);
    end

    // Card Grid Rendering
    wire [3:0] card_x, card_y;
    assign card_x = h_count[9:6];  // Divide horizontal position into 16 segments
    assign card_y = v_count[9:6];  // Divide vertical position into 16 segments

    // Color Generation
    reg [3:0] r, g, b;
    always @(*) begin
        if (!video_on) begin
            // Blanking region
            {r, g, b} = 12'h000;
        end else begin
            // Render card grid
            case (card_states[{card_y[1:0], card_x[1:0]}])
                2'b00: begin  // Face down card
                    {r, g, b} = 12'h555;  // Gray
                end
                2'b01: begin  // Flipped card
                    {r, g, b} = 12'hAAA;  // Light Gray
                end
                2'b10: begin  // Matched card
                    {r, g, b} = 12'h0F0;  // Green
                end
                default: begin
                    {r, g, b} = 12'h000;  // Black
                end
            endcase

            // Highlight cursor position
            if ({card_y[1:0], card_x[1:0]} == cursor_pos) begin
                {r, g, b} = 12'hF00;  // Red cursor highlight
            end
        end
    end

    // Output assignments
    assign red = r;
    assign green = g;
    assign blue = b;

endmodule
