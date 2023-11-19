module cpu(clk, reset, s, load, in, out, N, V, Z, w);
    input clk, reset, s, load;
    input [15:0] in;
    output [15:0] out;
    output N, V, Z, w;

    reg [15:0] current_intruction;
    reg nsel;
    reg [2:0] opcode;
    reg [2:0] ALUop;
    reg [1:0] op;
    reg [15:0] sximm5;
    reg [15:0] sximm8;
    reg [1:0] shift;
    reg 

    //INSTRUCTION REGISTER: The instruction currently being executed is stored in the 16 bit instruction register
    //Input: clk, load, in
    //Output: current_instruction
    always @(posedge clk) begin
        case (load)
            1'b0 : current_intruction = current_intruction; //nothing happens
            1'b1 : current_intruction <= in; //in is copied to IR
            default: current_intruction = current_intruction;
        endcase
    end

    //INSTRUCTION DECODER: (Combinational) Extracts information from the current instruction that is used to control the datapath. (takes in nsel from FSM)
    //Input: current_instruction, nsel
    //Output: opcode, op/ALuop, shift, readnum, writenum, sximm5, sximm8
    always @(*) begin
        //get opcode op/ALUop, shift

        //with nsel, make a mux for Rn, Rd, Rm to readnum and writenum

        //sign extend imm5 and imm8
    end

    //FSM: Sets the inputs to the datapath based on stuff. (takes in opcode and op from decoder)
    always @(posedge clk) begin

    end


endmodule: cpu