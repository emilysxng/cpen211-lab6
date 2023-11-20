module cpu(clk, reset, s, load, in, out, N, V, Z, w);
    input clk, reset, s, load;
    input [15:0] in;
    output [15:0] out;
    output N, V, Z, w;

    reg [15:0] current_intruction;
    reg [2:0] nsel;
    reg [2:0] opcode;
    reg [2:0] ALUop;
    reg [1:0] op;
    reg [7:0] imm8;
    reg [7:0] imm5;
    reg [15:0] sximm5;
    reg [15:0] sximm8;
    reg [1:0] shift;
    reg [2:0] Rd;
    reg [2:0] Rm;
    reg [2:0] Rn;

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
        //extract data from current_instruction
        assign opcode = current_instruction[15:13];
        assign op = current_instruction[12:11];
        assign ALUop = op;
        assign Rn = current_instruction[10:8];
        assign Rd = current_instruction[7:5];
        assign Rm = current_instruction[2:0];
        assign shift = current_instruction[4:3];
        assign imm8 = current_instruction[7:0];
        assign imm5 = current_instruction[4:0];

        //with nsel, make a mux for Rn, Rd, Rm to readnum and writenum
        case(nsel)
            3'b100: readnum = Rn;
            3'b010: readnum = Rd;
            3'b001: readnum = Rm;
            default: readnum = Rn;
        endcase

        assign writenum = readnum;

        //sign extend imm5 and imm8
        if (imm8[7] == 1) begin
            assign sximm8 = {8'b11111111, imm8};
        end else begin
            assign sximm8 = {8'b00000000, imm8};
        end

        if (imm5[4] == 1) begin
            assign sximm5 = {11'b11111111, imm5};
        end else begin
            assign sximm5 = {11'b00000000, imm5};
        end
    end

    //FSM: Sets the inputs to the datapath based on stuff. (takes in opcode and op from decoder)
    //Input: clk, opcode, op, s, reset
    //Output: w, nsel, all settings to the datapath

    always @(posedge clk) begin

    end


endmodule: cpu