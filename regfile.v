module regfile(
       input CLK,
       input reset_n,
       input [4:0] rs1_addr,
       input [4:0] rs2_addr,
       output [31:0] rs1_data,
       output [31:0] rs2_data,
       input[4:0] rd_addr,
       input [31:0] rd_data,
       input reg_write
    );
       reg [31:0] regs [0:31];
       assign rs1_data=(rs1_addr==5'b0)?32'b0:regs[rs1_addr];
       assign rs2_data=(rs2_addr==5'b0)?32'b0:regs[rs2_addr];
       integer i;
   always@(posedge CLK or negedge reset_n)
       if(!reset_n)
            for(i=0;i<32;i=i+1)
               regs[i]<=32'b0;
       else begin
            if(reg_write && (rd_addr != 5'b0))
                  regs[rd_addr]<=rd_data;
       end        
endmodule
