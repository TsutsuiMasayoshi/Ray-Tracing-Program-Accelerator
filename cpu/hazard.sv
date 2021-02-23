module hazard(input logic[1:0] fpustall,readflag,
              input logic[6:0] rsd,rtd,rdd,rse,rte,rde,
              input logic[4:0] writerege,writeregm,writeregw,
              input logic[2:0] branch,
              input logic memtorege,memtoregm,memtoregw,
              input logic[1:0] regwritee,regwritem,regwritew,jump, 
              output logic stall,
              output logic[1:0] forwardad,forwardbd,forwardcd,forwardae,forwardbe,forwardce
              );
    
    logic lwstall,branchstall,jrstall;
              
    assign forwardae = (((rse=={2'b00,writeregm}) & regwritem == 2'b01) | ((rse=={2'b01,writeregm}) & regwritem == 2'b10))? 2'b10:(((rse == {2'b00,writeregw}) & regwritew == 2'b01) | ((rse=={2'b01,writeregw}) & regwritew == 2'b10))? 2'b01: 2'b00; 
    assign forwardbe = (((rte=={2'b00,writeregm}) & regwritem == 2'b01) | ((rte=={2'b01,writeregm}) & regwritem == 2'b10))? 2'b10:(((rte == {2'b00,writeregw}) & regwritew == 2'b01) | ((rte=={2'b01,writeregw}) & regwritew == 2'b10))? 2'b01: 2'b00;
    assign forwardce = (rde=={2'b00,writeregm}&regwritem==2'b01)? 2'b10:(rde=={2'b00,writeregw}&regwritew==2'b01)? 2'b01: 2'b00;
    assign forwardad = (((rsd == {2'b00,writeregm}) & regwritem == 2'b01) |((rsd == {2'b01,writeregm}) & regwritem == 2'b10))? 2'b10:(((rsd == {2'b00,writeregw}) & regwritew == 2'b01) |((rsd == {2'b01,writeregw}) & regwritew == 2'b10))? 2'b01:2'b00;
   assign forwardbd = (((rtd == {2'b00,writeregm}) & regwritem == 2'b01)|((rtd == {2'b01,writeregm}) & regwritem == 2'b10))? 2'b10:(((rtd == {2'b00,writeregw}) & regwritew == 2'b01)|((rtd == {2'b01,writeregw}) & regwritew == 2'b10))? 2'b01:2'b00;
    assign forwardcd = (rdd=={2'b00,writeregm}&regwritem==2'b01)? 2'b10:(rdd=={2'b00,writeregw}&regwritew==2'b01)? 2'b01: 2'b00;
    assign lwstall = (((rsd==rte) | (rtd == rte) | (rdd == rte)) & memtorege)? 1'b1:1'b0;
    assign branchstall = ((((branch[2] == 1'b1) & memtoregm & ({2'b01,writeregm} == rsd | {2'b01,writeregm} == rtd)) | ((branch[2] == 1'b1) & (regwritee == 2'b10) & ({2'b01,writerege} == rsd | {2'b01,writerege} == rtd))) |(((branch!=0) & memtoregm & ({2'b00,writeregm} == rsd | {2'b00,writeregm} == rtd)) | ((branch!=0) & (regwritee == 2'b01) & ({2'b00,writerege} == rsd | {2'b00,writerege} == rtd))))? 1'b1:1'b0;
    assign jrstall = ((jump == 2'b10) & memtoregm & ({1'b0,writeregm} == rsd))? 1'b1:1'b0;
    assign stall = (lwstall == 1 | branchstall == 1 | jrstall == 1 | fpustall > 0 | readflag != 0)? 1'b1:1'b0;
    
endmodule
