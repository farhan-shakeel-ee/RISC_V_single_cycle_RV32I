module risc_v #(
    parameter OPCODE_WIDTH = 7,
    parameter FUNCT3_WIDTH = 3,
    parameter FUNCT7_WIDTH = 7,
    parameter IMM_SEL_WIDTH = 3
)(
    input logic clk,
    input logic rst
);

logic wr_en3;
logic [3:0] alu_control;
logic [1:0]pc_sel;
logic [IMM_SEL_WIDTH-1:0] imm_sel;
logic [1:0] alu_sel1;
logic alu_sel2;
logic result_sel;
logic mem_wr;
logic zero;
logic [OPCODE_WIDTH-1:0] opcode;
logic [FUNCT3_WIDTH-1:0] funct3;
logic [FUNCT7_WIDTH-1:0] funct7;
logic [31:0] ALU_Result;
logic rd_sel;

risc_v_datapath datapath (
    .clk(clk),
    .rst(rst),
    .wr_en3(wr_en3),
    .alu_control(alu_control),
    .pc_sel(pc_sel),
    .result_sel(result_sel),
    .mem_wr(mem_wr),
    .imm_sel(imm_sel),
    .alu_sel1(alu_sel1),
    .alu_sel2(alu_sel2),
    .rd_sel(rd_sel),
    .zero(zero),
    .ALU_Result(ALU_Result),
    .opcode(opcode),
    .funct3(funct3),
    .funct7(funct7)
);

risc_v_controller controller (
    .zero(zero),
    .funct7(funct7),
    .funct3(funct3),
    .opcode(opcode),
    .ALU_Result(ALU_Result),
    .pc_sel(pc_sel),
    .imm_sel(imm_sel),
    .alu_sel1(alu_sel1),
    .alu_sel2(alu_sel2),
    .rd_sel(rd_sel),
    .wr_en3(wr_en3),
    .alu_control(alu_control),
    .result_sel(result_sel),
    .mem_wr(mem_wr)
);

endmodule