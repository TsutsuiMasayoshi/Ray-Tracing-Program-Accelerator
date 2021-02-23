module testbench();
  logic clk;
  logic reset;

  logic [31:0] writedata,dataadr;
  logic memwrite;
  logic[1:0] initial_valid = 0;
  logic [31:0] recvdata;
  logic [7:0] ansdata,ansdata2,test_data;
  logic [8:0] count;
  logic valid,valid2,recv_valid;
  logic[31:0] sld_file[1000:0];
  logic state;
  logic readflag;
  assign recv_valid = 0;

  top dut(clk,reset,recvdata,recv_valid,ansdata2,valid2,readflag);
  //uart_back ub(ansdata,valid,txd,clk,~reset);
  //uart_in ui(txd,readflag,recvdata,recv_valid,clk,~reset);
  
  initial
    begin
      reset <= 1; #22; reset <= 0;
      $readmemb("sld.dat",sld_file);
    end

  always
    begin
      clk <= 1; #30;clk <= 0; #30;
    end
  
  /*
  always @(posedge clk) begin
    if (reset) begin
        count <= 0;
        state <= 0;
    end else 
    if (readflag != 0 & state == 0) begin
        ansdata <= sld_file[count];
        valid <= 1;
        count <= count + 1;
        state <= 1;
    end else if (state == 1) begin
        valid <= 0;
        if (readflag == 0) begin
            state <= 0;
        end
    end
  end
  */
  
/*
  always @(negedge clk) begin
    if (initial_valid == 0) begin
        ansdata <= 10;
        valid <= 1;
        initial_valid <= 1;
    end else if (initial_valid == 1) begin
        valid <= 0;
    end
  end
*/

/*
  always @(negedge clk) begin
    if (initial_valid == 0) begin
        ansdata <= 10;
        valid <= 1;
        initial_valid <= 1;
    end
    if (recvdata == ansdata & initial_valid == 1) begin
       ansdata <= 9;
       valid <= 1;
       initial_valid <= 2;
    end else
    if (initial_valid == 2) begin
        valid <= 0;
    end
  end

*/
/*
  always @(negedge clk)
    begin
      if (memwrite) begin
        if(dataadr === 84 & writedata === 7) begin
          $display ("Simulation succeeded");
          $stop;
        end else if (dataadr !== 80) begin
          $display ("Simulation failed");
          $stop;
        end
      end
    end
 */
  endmodule
