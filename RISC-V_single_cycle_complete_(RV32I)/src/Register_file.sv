module register_file #(
    parameter WIDTH = 32,
    parameter REG_NUM = 32,
    parameter ADDR_WIDTH = $clog2(REG_NUM)
)(
    input  logic                  clk,
    input  logic                  rst,
    input  logic [ADDR_WIDTH-1:0] A1,
    input  logic [ADDR_WIDTH-1:0] A2,
    input  logic [ADDR_WIDTH-1:0] A3,
    input  logic                  WE3,
    input  logic [WIDTH-1:0]      WD3,
    output logic [WIDTH-1:0]      RD1,
    output logic [WIDTH-1:0]      RD2
);

logic [WIDTH-1:0] reg_array [0:REG_NUM-1];
integer i;

// Asynchronous reads .......,,,,,... it is mentioned in BOOK of DAVID HARIS 
always @(*) begin
    RD1 = (A1 == 0) ? '0 : reg_array[A1]; // at A1 == 0 there is zero REGISTER
    RD2 = (A2 == 0) ? '0 : reg_array[A2]; // at A2 == 0 there is zero REGISTER
end

// Synchronous write
always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        for (i = 0; i < REG_NUM; i++)
            reg_array[i] <= '0;
    end
    else if (WE3 && (A3 != 0)) begin // A3 should not be zero because at addr zero there is zero reg, which is hardcoded 0.....................
        reg_array[A3] <= WD3;
    end
end

endmodule