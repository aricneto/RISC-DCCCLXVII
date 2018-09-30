`timescale 1ps/1ps

module testbench;
    localparam CLKPERIOD = 10000;
    localparam CLKDELAY = CLKPERIOD / 2; 

    logic clk;
    logic nrst;
    
    initial clk = 1'b1;	
    always #(CLKDELAY) clk = ~clk;

    //clock generate
    initial
    begin
        nrst = 1'b1;
        #(CLKPERIOD)
        nrst = 1'b0;
        #(CLKPERIOD)
        #(CLKPERIOD)
        nrst = 1'b1;  
    end
        
    parameter ramSize = 65536;
    parameter ramAddrWide = $clog2(ramSize);
    reg [ramAddrWide-1:0]rdaddress;
        
    wire [63:0]q;
    
    always_ff @(posedge clk or negedge nrst)
    begin
        if(~nrst) begin
            rdaddress <= 8;
        end
        else begin
            if(rdaddress < ramSize) begin
                rdaddress <= rdaddress + 8;
            end
            else begin
                rdaddress <= 0;
            end
        end
    end
    
    /*rectiControl #(.imageWidth(imageWidth),
                 .imageHeight(imageHeight)
                )
                rectiControlInst1     
                (.clk(clk), .nrst(nrst), .start_module(start_cvt),
                 .rowO(rowO), .colO(colO),
                 .rowcolready(rowcolready)
                );*/
                
            
    /*ramOnChip #(.ramSize(ramTotalSize),
           .ramWide(fifoWide), 
           //.ramAddrWide(ramAddrWide)            
        ) 
        l1FifoInst1   
        (.clock(clk), 
         .data(), 
         .rdaddress(rdaddress),
         .wraddress(),
         .wren(rowcolready),
         .q(q) 
        ); */
        
    /*Memoria meminst 
    (.Address(rdaddress),
     .Clk(clk),         
     .Datain(),
     .Dataout(q),
     .Wr()
    );*/
    
    Memoria64 meminst 
    (.Address(rdaddress),
     .Clk(clk),         
     .Datain(),
     .Dataout(q),
     .Wr()
    );
    
    /*genericByPass
    #(.parallelismDepth(2),
      .imageWidthWide(imageWidthWide),
      .imageHeightWide(imageHeightWide)
    )
    genericByPassInst1	 
    (.clk(clk), 
     .nrst(nrst),
     .start(rowcolready),
     .rowI(rowO),
     .colI(colO),
     .rowO(rowOFromGen),
     .colO(colOFromGen), 
     .byPassEnd(endIntToSingle)   
    );*/
    
    /*singleFPtoInt singleFPtoIntInst1  (.clk(clk), 
                   .nrst(nrst),
			       .start_cvt(start_cvt),
			       .signal_in(inputData1[31]), .exponent_in(inputData1[30:23]), .mantissa_in(inputData1[22:0]), //floating-point number
			       .result(result),
			       .end_out(endFP)
	    );
	    
	intToSingleFP intToSingleFPInst1(
	               .clk(clk), 
                   .nrst(nrst),
                   .start_cvt(endFP),
                   .byteInput(result[11:0]),
                   .signal_out(signal_out), .exponent_out(exponent_out), .mantissa_out(mantissa_out),
                   .end_out(endIntToSingle)
                   
                   );*/
                   
                   
     
 
  /*rectiControl #(.imageWidth(imageWidth),
                 .imageHeight(imageHeight)
                )
                rectiControlInst1     
                (.clk(clk), 
                 .nrst(nrst), 
                 .rowO(rowO),
                 .colO(colO)
                );*/
                
                
 
endmodule
