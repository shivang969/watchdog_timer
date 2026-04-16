module system_controller_fsm (
    input  wire clk,
    input  wire rst_n,        
    input  wire start_work,   
    input  wire force_error,  
    input  wire wdt_timeout,  
    output reg  sys_ready,    
    output reg  wdt_kick      
);

    localparam IDLE    = 2'b00;
    localparam WORK    = 2'b01;
    localparam STUCK   = 2'b10;
    localparam RECOVER = 2'b11;

    reg [1:0] current_state;
    reg [1:0] next_state;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
        end else if (wdt_timeout) begin
            current_state <= RECOVER;
        end else begin
            // Normal state transition
            current_state <= next_state;
        end
    end

    always @(*) begin

        next_state = current_state; 
        sys_ready  = 1'b0;
        wdt_kick   = 1'b0;

        case (current_state)
            IDLE: begin
                sys_ready = 1'b1;
                wdt_kick  = 1'b1; 
                if (start_work) 
                    next_state = WORK;
            end
            
            WORK: begin
                wdt_kick = 1'b1;
                if (force_error) 
                    next_state = STUCK;
                else 
                    next_state = IDLE;
            end
            
            STUCK: begin
                next_state = STUCK;
            end
            
            RECOVER: begin
                wdt_kick = 1'b1;  
                next_state = IDLE;
            end
            
            default: next_state = IDLE;
        endcase
    end

endmodule
