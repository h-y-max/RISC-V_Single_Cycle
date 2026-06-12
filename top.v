module top(
       input CLK,
       input reset_n,
       output [31:0] pc,
       output [31:0] inst
    );
 wire [31:0] pc_to_imem;
 wire [31:0] inst_from_imem;
 
 wire [6:0] opcode;
 wire [4:0] rs1;
 wire [4:0] rs2;
 wire [4:0] rd;
 wire [2:0] funct3;
 wire [6:0] funct7;
 wire [31:0] imm_i;
 wire [31:0] imm_s;
 wire [31:0] imm_b;
 wire [31:0] imm_j;
 wire [31:0] imm_u;

wire reg_write;
wire alu_src;
wire mem_write;
wire mem_to_reg;
wire branch;
wire jump;
wire [3:0] alu_op;

wire [31:0] rs1_data;
wire [31:0] rs2_data;
wire [31:0] alu_result;
wire [31:0] mem_read_data;

wire branch_taken;
wire [31:0] branch_target;
wire [31:0] jump_target;

wire [31:0] reg_write_data;
//pc
pc pc_inst0(
    .CLK(CLK),
    .reset_n(reset_n),
    .branch_taken(branch_taken),
    .branch_target(branch_target),
    .jump_taken(jump),
    .jump_target(jump_target),
    .pc(pc_to_imem)
  );
 //imem
 imem imem_inst0(
       .addr(pc_to_imem),
       .inst(inst_from_imem)
  );
 //decoder
 decoder decoder_inst0(
       .inst(inst_from_imem),
       .opcode(opcode),
       .rd(rd),
       .rs1(rs1),
       .rs2(rs2),
       .funct3(funct3),
       .funct7(funct7),
       .imm_i(imm_i),
       .imm_s(imm_s),
       .imm_b(imm_b),
       .imm_j(imm_j),
       .imm_u(imm_u)
);
//control
control control_inst0(
       .opcode(opcode),
       .funct3(funct3),
       .funct7(funct7),
       .reg_write(reg_write),
       .alu_src(alu_src),
       .mem_write(mem_write),
       .mem_to_reg(mem_to_reg),
       .branch(branch),
       .jump(jump),
       .alu_op(alu_op)
 );
//regfile
 regfile regfile_inst0(
       .CLK(CLK),
       .reset_n(reset_n),
       .rs1_addr(rs1),
       .rs2_addr(rs2),
       .rs1_data(rs1_data),
       .rs2_data(rs2_data),
       .rd_addr(rd),
       .rd_data(reg_write_data),
       .reg_write(reg_write)
  );
//alu
 wire [31:0] alu_b;
 assign alu_b=(alu_src==1)?imm_i:rs2_data;
 alu alu_inst0(
       .a(rs1_data),
       .b(alu_b),
       .alu_op(alu_op),
       .result(alu_result)
 );
 //dmem
 dmem dmem_inst0(
       .CLK(CLK),
       .addr(alu_result),
       .write_en(mem_write),
       .write_data(rs2_data),
       .read_data(mem_read_data)
  );
  
  wire [31:0] jalr_target;
  assign jalr_target=rs1_data+imm_i;
  assign jump_target=(opcode==7'b1101_111)?(pc_to_imem+imm_j):jalr_target;
  
  assign reg_write_data=(mem_to_reg==1)?mem_read_data:alu_result;
  assign branch_taken=branch && ((funct3==3'b000 && alu_result==32'b0)||(funct3==3'b001 && alu_result!==32'b0));
  assign branch_target=pc_to_imem+imm_b;
  assign pc=pc_to_imem;
  assign inst=inst_from_imem;
endmodule
