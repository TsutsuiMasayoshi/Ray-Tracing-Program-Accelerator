module mips(input logic clk,
            input logic reset,
            output logic[13:0] pc,
            input logic[31:0] instr,
            output logic memwrite,
            output logic[1:0] out,
            output logic[31:0] aluout,
            output logic[31:0] writedata,
            output logic[1:0] readflag,
            input logic[31:0] readdata,
            input logic[31:0] recv_data,
            input logic recv_valid);

  logic       memtorege,memtoregm,memtoregw,regdst,pcsrc,equalid,sltid,equalid2,sltid2,rawrite;
  logic[1:0]  jump,regwritee,regwritem,regwritew,alusrc;
  logic       soru,bsltiflag;
  logic       stall;
  logic[1:0]  forwardad,forwardbd,forwardae,forwardbe,forwardmtc,fpustall,aorf,regaorf1,regaorf2,rf3flagd,rf3flagw,forwardcd,forwardce;
  logic[6:0]  rsd,rtd,rse,rte,rdd,rde;
  logic[4:0]  writerege,writeregm,writeregw;
  logic[2:0]  alucontrol,branch;
  logic[3:0]  fpucontrol;
  logic[31:0] instrd;

  controller c(clk,reset,instrd[31:26],instrd[5:0],instrd[10:6],equalid,sltid,equalid2,sltid2,stall,recv_valid,memtorege,memtoregm,memtoregw,memwrite,pcsrc,alusrc,regdst,rawrite,regwritee,regwritem,regwritew,branch,jump,soru,bsltiflag,readflag,out,regaorf1,regaorf2,rf3flagd,rf3flagw,aorf,alucontrol,fpucontrol,fpustall);
  datapath dp(clk,reset,branch,memtoregw,pcsrc,alusrc,regdst,regwritew,rawrite,jump,soru,bsltiflag,alucontrol,fpucontrol,regaorf1,regaorf2,rf3flagd,rf3flagw,aorf,recv_data,recv_valid,readflag,equalid,sltid,equalid2,sltid2,pc,instr,aluout,writedata,readdata,forwardad,forwardbd,forwardcd,forwardae,forwardbe,forwardce,stall,fpustall,rsd,rtd,rdd,rse,rte,rde,writerege,writeregm,writeregw,instrd);
  hazard   hz(fpustall,readflag,rsd,rtd,rdd,rse,rte,rde,writerege,writeregm,writeregw,branch,memtorege,memtoregm,memtoregw,regwritee,regwritem,regwritew,jump,stall,forwardad,forwardbd,forwardcd,forwardae,forwardbe,forwardce);
endmodule
