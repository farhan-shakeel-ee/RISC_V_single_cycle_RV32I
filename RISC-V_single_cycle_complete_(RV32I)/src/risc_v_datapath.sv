module risc_v_datapath #(
    parameter WIDTH =32,
    parameter OPCODE_WIDTH = 7,
    parameter FUNCT3_WIDTH = 3,
    parameter FUNCT7_WIDTH = 7,
    parameter IMM_SEL_WIDTH = 3
)(
    input logic clk,
    input logic rst,
    input logic wr_en3,
    input logic [3:0] alu_control,
    output logic zero,
    output logic [WIDTH-1:0] ALU_Result,
    input logic [1:0]pc_sel,
    input logic result_sel,
    input logic mem_wr,
    input logic [IMM_SEL_WIDTH-1:0] imm_sel,
    input logic [1:0]alu_sel1,
    input logic alu_sel2,
    input logic rd_sel,
    output logic [OPCODE_WIDTH-1:0] opcode,
    output logic [FUNCT3_WIDTH-1:0] funct3,
    output logic [FUNCT7_WIDTH-1:0] funct7
);

logic [WIDTH-1:0] pc_next;
logic [WIDTH-1:0] pc;
logic [WIDTH-1:0] instruction;
logic [WIDTH-1:0] write_data;
logic [WIDTH-1:0] operand1;
logic [WIDTH-1:0] operand2;
logic [WIDTH-1:0] immediate;
logic [WIDTH-1:0] Result;
logic [WIDTH-1:0] Read1;
logic [WIDTH-1:0] Read2;
logic [WIDTH-1:0] PC_plus_4;
logic [WIDTH-1:0] RD_mem;
logic [WIDTH-1:0] load_data;
logic [WIDTH-1:0] pc_jump;
logic [WIDTH-1:0] pc_jalr;


program_counter PC (
    .clk(clk),
    .rst(rst),
    .pc_next(pc_next),
    .pc(pc)
);

instruction_memory instr_mem (
    .A(pc),
    .RD(instruction)
);

register_file reg_file(
    .clk(clk),
    .rst(rst),
    .A1(instruction[19:15]),
    .A2(instruction[24:20]),
    .A3(instruction[11:7]),
    .WE3(wr_en3),
    .WD3(write_data),
    .RD1(Read1),
    .RD2(Read2)
);


risc_alu ALU (
    .operand1(operand1),
    .operand2(operand2),
    .alu_operations(alu_control),
    .ALU_Result(ALU_Result),
    .Zero(zero)
);

imm_gen immediate_gen(
    .imm_inp(instruction[31:7]),
    .imm_sel(imm_sel),
    .immediate(immediate)
);

data_memory data_mem (
    .clk(clk),
    .rst(rst),
    .funct3(funct3),
    .A(ALU_Result),
    .WD(Read2),
    .WE(mem_wr),
    .RD(RD_mem)
);



always @(*) begin
    PC_plus_4 = pc + 32'd4;
    opcode    = instruction[6:0];
    funct3    = instruction[14:12];
    funct7    = instruction[31:25];
    pc_jump  = pc + immediate;
    pc_jalr  = (Read1 + immediate) & 32'hFFFFFFFE; 

    case(pc_sel)
        2'b00: pc_next = PC_plus_4;
        2'b11: pc_next = pc_jump;
        2'b01: pc_next = pc_jalr;
        default: pc_next = PC_plus_4;
    endcase

    operand2 = alu_sel2 ? immediate : Read2;
    case(alu_sel1)
        2'b00: operand1 = pc;
        2'b01: operand1 = '0;
        2'b11: operand1 = Read1;
        2'b10: operand1 = '0;
        default: operand1 = Read1;
    endcase
   
// Load unit logic 
    case (funct3)
        3'b000: begin
            case (ALU_Result[1:0])
                2'b00: load_data = {{24{RD_mem[7]}}, RD_mem[7:0]};
                2'b01: load_data = {{24{RD_mem[15]}}, RD_mem[15:8]};
                2'b10: load_data = {{24{RD_mem[23]}}, RD_mem[23:16]};
                default: load_data = {{24{RD_mem[31]}}, RD_mem[31:24]};
            endcase
        end
        3'b001: begin
            case (ALU_Result[1:0])
                2'b00: load_data = {{16{RD_mem[15]}}, RD_mem[15:0]};
                2'b10: load_data = {{16{RD_mem[31]}}, RD_mem[31:16]};
                default: load_data = RD_mem;
            endcase
        end
        3'b010: load_data = RD_mem;
        3'b100: begin
            case (ALU_Result[1:0])
                2'b00: load_data = {24'b0, RD_mem[7:0]};
                2'b01: load_data = {24'b0, RD_mem[15:8]};
                2'b10: load_data = {24'b0, RD_mem[23:16]};
                default: load_data = {24'b0, RD_mem[31:24]};
            endcase
        end
        3'b101: begin
            case (ALU_Result[1:0])
                2'b00: load_data = {16'b0, RD_mem[15:0]};
                2'b10: load_data = {16'b0, RD_mem[31:16]};
                default: load_data = RD_mem;
            endcase
        end
        default: load_data = RD_mem;
    endcase

    Result = result_sel ? load_data : ALU_Result;
    write_data = rd_sel ? PC_plus_4 : Result;
end

endmodule