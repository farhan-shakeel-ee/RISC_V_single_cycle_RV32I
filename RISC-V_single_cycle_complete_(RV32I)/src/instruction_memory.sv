module instruction_memory #(
    parameter WIDTH = 32,
    parameter DEPTH = 256
)(
    input  logic [WIDTH-1:0] A,
    output logic [WIDTH-1:0] RD
);

logic [WIDTH-1:0] instr_mem [0:DEPTH-1];
integer i;

initial begin
    $readmemh("program.hex", instr_mem);
end

always @(*) begin
    RD = instr_mem[A[31:2]];
end

endmodule