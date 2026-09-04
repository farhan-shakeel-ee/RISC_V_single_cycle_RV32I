module data_memory #(
    parameter WIDTH = 32,
    parameter DEPTH = 256
)(
    input  logic             clk,
    input  logic             rst,
    input  logic [2:0]       funct3,

    input  logic [WIDTH-1:0] A,
    input  logic [WIDTH-1:0] WD,
    input  logic             WE,

    output logic [WIDTH-1:0] RD
);

    logic [WIDTH-1:0] memory [0:DEPTH-1];
    logic [WIDTH-1:0] word;
    integer i;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < DEPTH; i = i + 1)
                memory[i] <= '0;
        end
        else if (WE) begin
            word = memory[A[31:2]];
            case (funct3)
                3'b000: begin
                    case (A[1:0])
                        2'b00: word[7:0]   = WD[7:0];
                        2'b01: word[15:8]  = WD[7:0];
                        2'b10: word[23:16] = WD[7:0];
                        2'b11: word[31:24] = WD[7:0];
                        default: word = word;
                    endcase
                end
                3'b001: begin
                    case (A[1:0])
                        2'b00: word[15:0]  = WD[15:0];
                        2'b10: word[31:16] = WD[15:0];
                        default: word = word;
                    endcase
                end
                default: word = WD;
            endcase
            memory[A[31:2]] <= word;
        end
    end

    always @(*) begin
        RD = memory[A[31:2]];
    end

endmodule