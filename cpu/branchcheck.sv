module branchcheck(input logic clk,
                   input logic [5:0] op,
                   input logic [13:0] pc,
                   input logic [13:0] beforepc,
                   input logic pcsrc,
                   input logic[2:0] branch,
                   output logic y);
    logic[1:0] predict[9000:0] = '{9001{2'b01}};
    logic [1:0]pre_sub;
    logic pre;
    assign pre_sub = predict[pc];
    assign pre = (pre_sub>1)? 1'b1:1'b0;
    
    always_comb
    case(op)
        6'b000100: y <= 0;
        6'b000101: y <= 0;
        6'b100000: y <= 0;
        6'b100001: y <= 0;
        6'b100010: y <= 0;
        6'b100100: y <= 0;
        6'b100101: y <= 0;
        6'b100110: y <= 0;
        6'b100111: y <= 0;
        6'b101000: y <= 0;
        6'b101001: y <= 0;
        6'b101010: y <= 0;
        6'b101100: y <= 0;
        default: y <= 1'b0;
    endcase
    
    always_ff @(posedge clk) begin
        if(pcsrc & (predict[beforepc] < 3)) begin
            predict[beforepc] <= predict[beforepc]+1;
        end else if ((pcsrc==0) & (predict[beforepc]>0))begin
            predict[beforepc] <= predict[beforepc]-1;
        end
    end
    
endmodule