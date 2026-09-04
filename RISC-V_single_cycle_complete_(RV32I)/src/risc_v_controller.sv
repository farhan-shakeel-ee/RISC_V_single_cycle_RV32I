module risc_v_controller #(
    parameter OPCODE_WIDTH  = 7,
    parameter FUNCT3_WIDTH  = 3,
    parameter FUNCT7_WIDTH  = 7,
    parameter IMM_SEL_WIDTH = 3,
    parameter WIDTH         = 32
)(
    input logic zero,
    input logic [FUNCT7_WIDTH-1:0] funct7,
    input logic [FUNCT3_WIDTH-1:0] funct3,
    input logic [OPCODE_WIDTH-1:0] opcode,
    input logic [WIDTH-1:0] ALU_Result,

    output logic [1:0]pc_sel,
    output logic [IMM_SEL_WIDTH-1:0] imm_sel,
    output logic [1:0] alu_sel1,
    output logic wr_en3,
    output logic [3:0] alu_control,
    output logic result_sel,
    output logic mem_wr, 
    output logic alu_sel2, 
    output logic rd_sel
);

    localparam logic [3:0]
        ALU_ADD  = 4'b0000,
        ALU_SUB  = 4'b0001,
        ALU_AND  = 4'b0010,
        ALU_OR   = 4'b0011,
        ALU_XOR  = 4'b0100,
        ALU_SLL  = 4'b0101,
        ALU_SRL  = 4'b0110,
        ALU_SRA  = 4'b0111,
        ALU_SLT  = 4'b1000,
        ALU_SLTU = 4'b1001;


    localparam logic [6:0]
        OPCODE_R      = 7'b0110011,
        OPCODE_I_ALU  = 7'b0010011,
        OPCODE_LOAD   = 7'b0000011,
        OPCODE_STORE  = 7'b0100011,
        OPCODE_BRANCH = 7'b1100011,
        OPCODE_LUI    = 7'b0110111,
        OPCODE_AUIPC  = 7'b0010111,
        OPCODE_JAL    = 7'b1101111,
        OPCODE_JALR   = 7'b1100111;

    always @(*) begin

        pc_sel      = 2'b00;
        imm_sel     = 3'b000;
        alu_sel1    = 2'b11;
        alu_sel2    = 1'b0;
        wr_en3      = 1'b0;
        alu_control = ALU_ADD;
        result_sel  = 1'b0;
        mem_wr      = 1'b0;
        rd_sel      = 1'b0;

        case (opcode)

            OPCODE_R: begin

                alu_sel2    = 1'b0;
                wr_en3      = 1'b1;

                case (funct3)

                    // ADD / SUB
                    3'b000: begin
                        if (funct7 == 7'b0100000)
                            alu_control = ALU_SUB;
                        else
                            alu_control = ALU_ADD;
                    end

                    // sll
                    3'b001: begin
                        alu_control = ALU_SLL;
                    end

                    // SLT
                    3'b010: begin
                        alu_control = ALU_SLT;
                    end

                    // SLTU
                    3'b011: begin
                        alu_control = ALU_SLTU;
                    end

                    // XOR
                    3'b100: begin
                        alu_control = ALU_XOR;
                    end

                    // SRL / SRA
                    3'b101: begin
                        if (funct7 == 7'b0100000)
                            alu_control = ALU_SRA;
                        else
                            alu_control = ALU_SRL;
                    end

                    // or 
                    3'b110: begin
                        alu_control = ALU_OR;
                    end

                    // aND
                    3'b111: begin
                        alu_control = ALU_AND;
                    end

                    default: begin
                        alu_control = ALU_ADD;
                    end

                endcase

            end

            OPCODE_LUI: begin

                alu_sel2    = 1'b1;
                alu_sel1    = 2'b01;
                wr_en3      = 1'b1;
                alu_control = ALU_ADD;
                imm_sel = 3'b110;
                result_sel  = 1'b0; 
                mem_wr      = 1'b0;

            end

            OPCODE_I_ALU: begin

                alu_sel2    = 1'b1;
                wr_en3      = 1'b1;
                imm_sel     = 3'b011;

                case (funct3)

                    3'b000: begin
                        alu_control = ALU_ADD;
                    end

                    // SLLI
                    3'b001: begin
                        alu_control = ALU_SLL;
                    end

                    // SLTI
                    3'b010: begin
                        alu_control = ALU_SLT;
                    end

                    // SLTIU
                    3'b011: begin
                        alu_control = ALU_SLTU;
                    end

                    // XORI
                    3'b100: begin
                        alu_control = ALU_XOR;
                    end

                    // SRLI / SRAI
                    3'b101: begin
                        if (funct7 == 7'b0100000)
                            alu_control = ALU_SRA;
                        else
                            alu_control = ALU_SRL;
                    end

                    // ORI
                    3'b110: begin
                        alu_control = ALU_OR;
                    end

                    // ANDI
                    3'b111: begin
                        alu_control = ALU_AND;
                    end

                    default: begin
                        alu_control = ALU_ADD;
                    end

                endcase

            end

            OPCODE_BRANCH: begin

                alu_sel2    = 1'b0;
                imm_sel     = 3'b100;

                case (funct3)

                    // BEQ
                    3'b000: begin
                        alu_control = ALU_SUB;
                        if(zero)
                            pc_sel = 2'b11;
                        else
                            pc_sel = 2'b00;

                    end

                    // BNE
                    3'b001: begin
                        alu_control = ALU_SUB;
                        if(~zero)
                            pc_sel = 2'b11;
                        else
                            pc_sel = 2'b00;
                    end

                    // BLT
                    3'b100: begin
                        alu_control = ALU_SLT;
                        if (ALU_Result != 0)
                            pc_sel = 2'b11;
                        else
                            pc_sel = 2'b00;
                    end

                    // BGE
                    3'b101: begin
                        alu_control = ALU_SLT;
                        if (ALU_Result == 0)
                            pc_sel = 2'b11;
                        else
                            pc_sel = 2'b00;
                    end

                    // BLTU
                    3'b110: begin
                        alu_control = ALU_SLTU;
                        if (ALU_Result != 0)
                            pc_sel = 2'b11;
                        else
                            pc_sel = 2'b00;
                    end

                    // BGEU
                    3'b111: begin
                        alu_control = ALU_SLTU;
                        if (ALU_Result == 0)
                            pc_sel = 2'b11; 
                        else
                            pc_sel = 2'b00;    

                    end

                    default: begin
                        alu_control = ALU_ADD;
                        pc_sel = 2'b00;
                    end

                endcase
            end

            OPCODE_AUIPC: begin
                alu_sel2    = 1'b1;
                alu_sel1    = 2'b00;
                wr_en3      = 1'b1;
                alu_control = ALU_ADD;
                imm_sel     = 3'b110;
                result_sel  = 1'b0;
                mem_wr      = 1'b0;
            end

            OPCODE_LOAD: begin

                alu_sel2    = 1'b1;
                wr_en3      = 1'b1;
                alu_control = ALU_ADD;
                imm_sel     = 3'b010;
                result_sel  = 1'b1;
                mem_wr      = 1'b0;

            end

            OPCODE_JAL:begin
                rd_sel = 1'b1;
                wr_en3 = 1'b1;
                pc_sel = 2'b11; 
                imm_sel = 3'b101;
            end 

            OPCODE_JALR: begin

                if (funct3 == 3'b000) begin

                    pc_sel = 2'b01;

                    alu_sel1    = 2'b11;     // Read1 = rs1
                    alu_sel2    = 1'b1;      // immediate
                    alu_control = ALU_ADD;

                    imm_sel     = 3'b010;    // I-type immediate

                    rd_sel      = 1'b1;      // PC + 4
                    wr_en3      = 1'b1;

                end

            end


            OPCODE_STORE: begin
                alu_sel2    = 1'b1;
                wr_en3      = 1'b0;
                alu_control = ALU_ADD;
                imm_sel     = 3'b001;
                result_sel  = 1'b0;
                mem_wr      = 1'b1;
            end

            default: begin

                pc_sel      = 2'b00;
                imm_sel     = 3'b000;
                alu_sel2    = 1'b0;
                wr_en3      = 1'b0;
                alu_control = ALU_ADD;
                result_sel  = 1'b0;
                mem_wr      = 1'b0;

            end

        endcase
    end
endmodule