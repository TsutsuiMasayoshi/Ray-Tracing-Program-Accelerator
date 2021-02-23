module controller(input logic clk,reset,
                  input logic[5:0] op,
                  input logic[5:0] funct,
                  input logic[4:0] second,
                  input logic equalid,sltid,equalid2,sltid2,
                  input logic flushe,
                  input logic recv_valid,
                  output logic memtorege,
                  output logic memtoregm,
                  output logic memtoregw,
                  output logic memwritem,
                  output logic pcsrcd,
                  output logic[1:0] alusrce,
                  output logic regdste,
                  output logic rawrite,
                  output logic[1:0] regwritee,regwritem,regwritew,
                  output logic[2:0] branchd,
                  output logic[1:0] jumpd,
                  output logic sorud,bsltiflagd,
                  output logic[1:0] readflagd,
                  output logic[1:0] outm,regaorfd1,regaorfd2,rf3flagd,rf3flagw,aorfe,
                  output logic[2:0] alucontrole,
                  output logic[3:0]fpucontrole,
                  output logic[1:0] fpustalle);
    logic[2:0] aluop;
    logic memtoregd,memwrited,memwritee,regdstd,recv_valid_;
    logic[2:0] alucontrold;
    logic[3:0] fpucontrold;
    logic[1:0] outd,oute,regwrited,aorfd,alusrcd;
    logic[1:0] fpustalld,readflage;
    logic[1:0] rf3flage,rf3flagm;

    maindec md(op,funct,second,recv_valid_,memtoregd,memwrited,branchd,alusrcd,regdstd,regwrited,rawrite,jumpd,sorud,outd,aluop,regaorfd1,regaorfd2,rf3flagd,aorfd,bsltiflagd,readflagd);
    aludec ad(funct,aluop,alucontrold);
    fpudec fd(op,funct,second,fpucontrold,fpustalld);
    assign pcsrcd = (branchd == 3'b001)? equalid: (branchd==3'b010)? (!equalid): (branchd==3'b011)? sltid: (branchd==3'b100)? equalid2: (branchd==3'b101)? sltid2: 1'b0;
    always @(posedge clk) begin
        if (reset) begin
            regwritem <= 2'b00;
            regwritew <= 2'b00;
            memtoregm <= 1'b0;
            memtoregw <= 1'b0;
            memwritem <= 1'b0;
            regwritee <= 0;
            rf3flage <= 2'b00;
            rf3flagm <= 2'b00;
            rf3flagw <= 2'b00;
            memtorege <= 0;
            memwritee <= 0;
            oute <= 0;
            outm <= 0;
            alusrce <= 0;
            regdste <= 0;
            alucontrole <= 3'b000;
            fpustalle <= 2'b00;
        end else begin
            regwritew <= regwritem;
            rf3flagw <= rf3flagm;
            memtoregw <= memtoregm;
            recv_valid_ <= recv_valid;
            if (readflagd != 2'b00 & readflage != 2'b00) begin
                regwritem <= 0;
                rf3flagm <= 0;
                memtoregm <= 0;
                memwritem <= 0;
                outm <= 0;
            end else if (fpustalle > 0) begin
                fpustalle <= fpustalle - 1;
                regwritem <= 0;
                rf3flagm <= 0;
                memtoregm <= 0;
                memwritem <= 0;
                outm <= 0;
                //regwritee <= 0;
                //memtorege <= 0;
                //memwritee <= 0;
            end else begin
                regwritem <= regwritee;
                rf3flagm <= rf3flage;
                memtoregm <= memtorege;
                memwritem <= memwritee;
                outm <= oute;
                if (flushe) begin
                    regwritee <= 0;
                    rf3flage <= 0;
                    memtorege <= 0;
                    memwritee <= 0;
                    alusrce <= 0;
                    regdste <= 0;
                    oute <= 0;
                    aorfe <= 0;
                    fpustalle <= 0;
                    readflage <= 0;
                    alucontrole <= 3'b000;
                    fpucontrole <= 4'b0000;
                end else begin
                    regwritee <= regwrited;
                    rf3flage <= rf3flagd;
                    memtorege <= memtoregd;
                    memwritee <= memwrited;
                    alusrce <= alusrcd;
                    regdste <= regdstd;
                    oute <= outd;
                    aorfe <= aorfd;
                    fpustalle <= fpustalld;
                    readflage <= readflagd;
                    alucontrole <= alucontrold;
                    fpucontrole <= fpucontrold;
                end
            end
        end
    end
endmodule
