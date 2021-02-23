module datapath(input logic clk,reset,
                input [2:0] branch,
                input logic memtoreg,pcsrc,
                input logic[1:0] alusrc,
                input logic regdst,
                input logic[1:0] regwrite,
                input logic rawrite,
                input logic[1:0] jump,
                input logic soru,bsltiflag,
                input logic[2:0] alucontrol,
                input logic[3:0] fpucontrol,
                input logic[1:0] regaorf1,regaorf2,rf3flagd,rf3flagw,aorf,
                input logic[31:0] recv_data,
                input logic recv_valid,
                input logic[1:0] readflag,
                output logic equalid,sltid,equalid2,sltid2,
                output logic[13:0] pc,
                input logic[31:0] instr,
                output logic [31:0] outm,writedatam,
                input logic[31:0] readdata,
                input logic[1:0] forwardad,forwardbd,forwardcd,
                input logic[1:0] forwardae,forwardbe,forwardce,
                input logic stall,
                input logic[1:0] fpustall,
                output logic[6:0] rsd,rtd,rdd,rse,rte,rde2,
                output logic[4:0] writerege,writeregm,writeregw,
                output logic[31:0] instrd
                );

    logic[13:0] pcplus4f,pcplus4d,pcbranchd,pcbranchd2;
    logic[31:0] signimmd,signimme,signimmshd;
    logic[31:0] srcae,srcbe,srcce;
    logic[31:0] resultw;
    logic[31:0] rd1,rd2,rd1d,rd2d,rd1e,rd2e,rd3,rd3d,rd3e;
    logic signed [31:0] x;
    logic[4:0] rde,shamte,rte2;
    logic[31:0] writedatae;
    logic[31:0] aluresult,oute,outw,fpuresult,intresult;
    logic[1:0] fpustalle,readflage;
    logic[4:0] rs,rt,rd;
    logic valid2,pcsrc2,valid3;
    logic[13:0] pcbranchf_sub,pcbranchf;
    logic[13:0] beforepc,beforepc2;
    logic branchpredictf,branchpredictd;
    logic [13:0] pc_sub;

    
    //fetch
    assign valid2 = (~(valid3)&branchpredictf);
    assign valid3 = (pcsrc&~branchpredictd)|(~pcsrc&branchpredictd);
    //branchcheck bc(clk,instr[31:26],pc,beforepc2,pcsrc2,branch,branchpredictf); //提出用は静的分岐予測を採用(詳細はレポート)
    assign branchpredictf = 1'b0;
    assign pcbranchf = pcplus4f + instr[13:0];
    flopr #(14) pcreg(clk,reset,pcplus4f,stall,pcbranchf,valid2,pcbranchd2,valid3,pc_sub);
    assign pc = (jump==2'b10)? rd1d[15:2]:(jump==2'b01)? {instrd[13:0]}: pc_sub;
    assign pcplus4f = pc+14'b1;
    assign pcbranchd2 = (branchpredictd)? pcplus4d:pcbranchd;
    
    //decode (write)
    assign rs = instrd[25:21];
    assign rt = instrd[20:16];
    assign rd = instrd[15:11];
    regfile     rf(clk,regwrite,rawrite,rs,rt,rd,writeregw,resultw,{16'b0,pc_sub,2'b00},regaorf1,regaorf2,outw,recv_data,recv_valid,readflag,rf3flagw,rd1,rd2,rd3);
    mux3 #(32)  a_mux(rd1,resultw,outm,forwardad,rd1d);
    mux3 #(32)  b_mux(rd2,resultw,outm,forwardbd,rd2d);
    mux3 #(32)  c_mux(rd3,resultw,outm,forwardcd,rd3d);
    signext     se(instrd[15:0],soru,signimmd);
    assign pcbranchd = pcplus4d + signimmd[13:0];
    
    assign x = (bsltiflag)? {27'b000000000000000000000000000,rt}:rd2d;
    assign equalid = (rd1d==x)? 1:0;
    assign sltid = ($signed(rd1d)<x)? 1:0;
    feq         feq(rd1d,rd2d,equalid2);
    fless       fless(rd1d,rd2d,sltid2);
    
    

    assign rsd = (regaorf1 == 2'b00)? {2'b00,rs}:(regaorf1 == 2'b01 | (rf3flagd != 0))? {2'b01,rs}: (regaorf1 == 2'b10)? {2'b10,rs}: {2'b11,rs};
    assign rtd = (regaorf2 == 2'b00)? {2'b00,rt}:(regaorf2 == 2'b01 | (rf3flagd != 0))? {2'b01,rt}: (regaorf2 == 2'b10)? {2'b10,rt}: {2'b11,rt};
    assign rdd = {2'b00,rd};
    
    //execute
    mux2 #(5)   wr_mux(rte2,rde,regdst,writerege);
    mux3 #(32)  srca_mux(rd1e,resultw,outm,forwardae,srcae);
    mux3 #(32)  write_mux(rd2e,resultw,outm,forwardbe,writedatae);
    mux3 #(32)  srcc_mux(rd3e,resultw,outm,forwardce,srcce);
    mux3 #(32)  srcb_mux_sub(writedatae,signimme,srcce,alusrc,srcbe);
    alu         alu(srcae,srcbe,shamte,alucontrol,aluresult);
    fpu         fpu(clk,srcae,srcbe,fpucontrol,intresult,fpuresult);
    assign oute = (aorf == 2'b00)? aluresult:(aorf == 2'b01)? fpuresult:intresult;
    
    //write
    mux2 #(32)  res_mux(outw,readdata,memtoreg,resultw);
    
    always @(posedge clk) begin
        if (reset) begin
           instrd <= 32'b11101000000000000000000000000000;
           branchpredictd <= 1'b0;
        end else begin
            beforepc <= pc;
            beforepc2 <= beforepc;
            pcsrc2 <= pcsrc;
            if (stall != 1 & (!valid3)) begin
                pcplus4d <= pcplus4f;
                branchpredictd <= branchpredictf;
                instrd <= instr;
            end else if((stall == 0) & (valid3)) begin
                instrd <= 32'b11101000000000000000000000000000;
                branchpredictd <= 1'b0;
            end
            if (fpustall == 0 & readflag == 0) begin
                rse <= rsd;
                rte <= rtd;
                rte2 <= rt;
                rde2 <= rdd;
                rde <= rd;
                signimme <= signimmd;
                rd1e <= rd1d;
                rd2e <= rd2d;
                rd3e <= rd3d;
                shamte <= instrd[10:6];
            end
            fpustalle <= fpustall;
            readflage <= readflag;
            writeregm <= writerege;
            writedatam <= writedatae;
            outm <= oute;
            outw <= outm;
            writeregw <= writeregm;
        end
    end
endmodule
