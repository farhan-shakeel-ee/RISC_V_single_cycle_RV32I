module program_counter #(
    parameter WIDTH = 32
)(
    input  logic        clk,
    input  logic        rst,
    input  logic [WIDTH-1:0] pc_next,
    output logic [WIDTH-1:0] pc
);

always_ff @(posedge clk or posedge rst) begin
    if (rst)
        pc <= {WIDTH{1'b0}};
    else
        pc <= pc_next;
end

endmodule