`timescale 1ns/1ps

module timer_module_tb();
    // Inputs
    reg clk;
    reg reset;
    reg start_timer;
    reg [15:0] delay;

    // Outputs
    wire timer_done;

    // Instantiate the Unit Under Test (UUT)
    timer_module uut (
        .clk(clk),
        .reset(reset),
        .start_timer(start_timer),
        .delay(delay),
        .timer_done(timer_done)
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
        start_timer = 0;
        delay = 16'd100;  // 100 clock cycles

        // Wait for global reset
        #100;
        reset = 0;

        // Test timer functionality
        #10 start_timer = 1;  // Start timer
        
        // Wait and observe timer_done
        #500;
        
        // Reset and try another delay
        #10 reset = 1;
        #10 reset = 0;
        delay = 16'd50;  // Shorter delay
        #10 start_timer = 1;

        // Run for a while
        #1000;

        // Finish simulation
        $finish;
    end

    // Optional: Waveform dumping
    initial begin
        $dumpfile("timer_module_tb.vcd");
        $dumpvars(0, timer_module_tb);
    end

    // Optional: Monitor timer state
    initial begin
        $monitor("Time=%0t reset=%b start_timer=%b delay=%d timer_done=%b", 
                  $time, reset, start_timer, delay, timer_done);
    end
endmodule
