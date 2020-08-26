interface memory_if;
    logic [15:0] wr_data_reg;
    wire [15:0] data;
    logic [15:0] addr;
    bit clk;
    bit rd;
    bit wr;
    
    modport mem_mp(inout data,
                  input addr,
                  input clk,
                  input rd,
                  input wr);
    
  modport tester(output wr_data_reg,
                  input clk,
                  output addr,
                  output rd,
                  output wr);
    
    assign data = (wr)? wr_data_reg: 16'hzzzz;
    
    initial begin 
      $monitor("addr: %1h data: %4h rd: %1b wr: %1b", addr, data, rd, wr);
      
      clk = 0;
      forever begin
        #10
        clk = ~clk;
      end 
    end
    
    logic [15:0] testmem [2**16-1:0];
    
    always @ (posedge clk) begin 
      if(rd) begin 
        #1;
        assert(data === testmem[addr]);
      end
      
      if(wr) begin 
        testmem[addr] = data;
      end 
    end 
      
  endinterface : memory_if