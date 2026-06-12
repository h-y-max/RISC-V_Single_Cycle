module control(
       input [6:0] opcode,
       input [2:0] funct3,
       input [6:0] funct7,
       output reg reg_write,
       output reg alu_src,
       output reg mem_write,
       output reg mem_to_reg,
       output reg branch,
       output reg jump,
       output reg [3:0] alu_op
    );
always@(*)begin
       reg_write=0;
       alu_src=0;
       mem_write=0;
       mem_to_reg=0;
       branch=0;
       jump=0;
       alu_op=4'b0000;//add
       
       case(opcode)
          7'b0110_011://RÐÍ
                 begin
                   reg_write=1;
                   alu_src=0;
                   case({funct7,funct3})
                       {7'b0000_000,3'b000}:alu_op=4'b0000;//add
                       {7'b0100_000,3'b000}:alu_op=4'b0001;//sub
                       {7'b0000_000,3'b111}:alu_op=4'b0011;//and
                       {7'b0000_000,3'b110}:alu_op=4'b0100;//or
                       {7'b0000_000,3'b010}:alu_op=4'b0101;//slt
                      default:alu_op=4'b0000;
                   endcase
                 end
          7'b0010_011://IÐÍ
                 begin
                    reg_write=1;
                    alu_src=1;
                    case(funct3)
                       3'b000:alu_op=4'b0000;//addi
                       3'b111:alu_op=4'b0011;//andi
                       3'b110:alu_op=4'b0100;//ori
                       3'b010:alu_op=4'b0101;//slti
                      default:alu_op=4'b0000;
                    endcase
                 end
          7'b0000_011://lw
                 begin
                    reg_write=1;
                    alu_src=1;
                    mem_to_reg=1;
                    alu_op=4'b0000;
                 end
          7'b0100_011://sw
                 begin
                    alu_src=1;
                    mem_write=1;
                    alu_op=4'b0000;
                 end
          7'b1100_011://beq,bne
                 begin
                    branch=1;
                    alu_op=4'b0001;//sub 
                 end
          7'b1101_111://jal
                 begin   
                    reg_write=1;
                    jump=1;
                 end
          7'b0110_111://lui
                 begin
                    reg_write=1;
                    alu_src=1;
                    alu_op=4'b0010;//pass
                 end
          7'b1100_111:
                 begin
                    reg_write=1;
                    jump=1;
                    alu_src=1;
                    alu_op=4'b0000;
                 end
       default:begin
                 reg_write=0;
                 alu_src=0;
                 mem_write=0;
                 mem_to_reg=0;
                 branch=0;
                 jump=0;
                 alu_op=4'b0000;
               end
    endcase
end
endmodule
