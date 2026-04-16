module watchdog_timer #(

    parameter TIMEOUT_VAL = 32'd1000 
) (
    input  wire clk,        
    input  wire rst_n,     
    input  wire enable,     
    input  wire kick,       
    output reg  wdt_timeout  
);
    reg [31:0] counter;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter     <= 32'd0;
            wdt_timeout <= 1'b0;
        end else if (enable) begin
            if (kick) begin
                counter     <= 32'd0;
                wdt_timeout <= 1'b0;
            end else if (counter >= TIMEOUT_VAL) begin
                counter     <= counter;
                wdt_timeout <= 1'b1;
            end else begin
                counter     <= counter + 1'b1;
                wdt_timeout <= 1'b0;
            end
        end
    end

endmodule
