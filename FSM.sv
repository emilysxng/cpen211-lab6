module FSM_controller (encoding,loada,loadb,loadc,shift,ALUop,vsel,write);

    input [15:0] encoding;
    output reg loada;
    output reg loadb;
    output reg loadc;
    output reg [1:0] shift;
    output reg [1:0] ALUop;
    output reg vsel;
    output reg write;

    always_ff @( posedge clk ) begin 

        case ({encoding[15],encoding[14],encoding[13]})
            3'b110: begin
                ALUop
            end
            default: 
        endcase
        
    end


    
endmodule