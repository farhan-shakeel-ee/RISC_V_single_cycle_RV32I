module imm_gen #(
    parameter IMM_IN_WIDTH = 25,
    parameter SEL_WIDTH     = 3,
    parameter WIDTH         = 32
)(
    input  logic [IMM_IN_WIDTH-1:0] imm_inp,
    input  logic [SEL_WIDTH-1:0]    imm_sel,
    output logic [WIDTH-1:0]        immediate
);

always @(*) begin

    case (imm_sel)

        // R-type  __________..............._____________..............__________
        3'b000: begin
            immediate = '0;
        end

        // S-type  __________..............._____________..............__________   
        3'b001: begin
            immediate = {{20{imm_inp[24]}},
                         imm_inp[24:18],
                         imm_inp[4:0]};
        end

        // I-type: LOAD and JALR ___________..............._____________..............__________
        3'b010: begin
            immediate = {{20{imm_inp[24]}},
                         imm_inp[24:13]};
        end

        // I-type immediate arithmetic _________..............._____________..............__________
        3'b011: begin

        case (imm_inp[7:5])  // funct3

        3'b001,            // SLLI
        3'b101: begin      // SRLI / SRAI
            immediate = {27'b0, imm_inp[17:13]};
        end

        default: begin
            immediate = {{20{imm_inp[24]}},
                        imm_inp[24:13]};
        end

        endcase

        end

        // B-type ___________..............._____________..............__________
        3'b100: begin
            immediate = {{19{imm_inp[24]}},
                         imm_inp[24],
                         imm_inp[0],
                         imm_inp[23:18],
                         imm_inp[4:1],
                         1'b0};
        end

       // J-type (JAL)
        3'b101: begin
            immediate = {{11{imm_inp[24]}},
                        imm_inp[24],
                        imm_inp[12:5],
                        imm_inp[13],
                        imm_inp[23:14],
                 1'b0};
        end

        // U-type ___________..............._____________..............__________
        3'b110: begin
            immediate = {imm_inp[24:5], 12'b0};
        end

        default: begin
            immediate = '0;
        end

    endcase

end

endmodule