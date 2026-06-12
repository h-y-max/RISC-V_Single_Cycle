module pc(
       input CLK,
       input reset_n,
       input branch_taken,            // 来自控制单元：beq指令且条件成立=1
       input [31:0] branch_target,    // 来自ALU：beq要跳转到的地址
       input jump_taken,              // 来自控制单元：jal指令=1
       input [31:0] jump_target,      // 来自立即数扩展：jal的目标地址
       output reg [31:0] pc
    );
       wire [31:0] pc_next;
assign pc_next=(jump_taken==1)?jump_target:(branch_taken==1)?branch_target:pc+32'd4;
always@(posedge CLK or negedge reset_n) 
       if(!reset_n)
           pc<=32'h0;
       else
           pc<=pc_next;          
endmodule
