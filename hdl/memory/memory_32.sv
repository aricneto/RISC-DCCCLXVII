/*-----------------------------------------------------------------------------
-- Title		: Memória da CPU
-- Project		: CPU 
--------------------------------------------------------------------------------
-- File			: memoria64.sv
-- Author		: Lucas Fernando da Silva Cambuim <lfsc@cin.ufpe.br>
-- Organization : Universidade Federal de Pernambuco
-- Created		: 20/09/2018
-- Last update	: 20/09/2018
-- Plataform	: DE2
-- Simulators	: ModelSim
-- Synthesizers	: 
-- Targets		: 
-- Dependency	: 
--------------------------------------------------------------------------------
-- Description	: Entidade responsável pela leitura e escrita em memória (dados de 64 bits).
--------------------------------------------------------------------------------
-- Copyright (c) notice
--		Universidade Federal de Pernambuco (UFPE).
--		CIn - Centro de Informatica.
--		Developed by computer science researchers.
--		This code may be used for educational and non-educational purposes as 
--		long as its copyright notice remains unchanged. 
------------------------------------------------------------------------------*/

module memory_32 #(
    parameter init_file = ""
)(
    // read and write address
    input wire [31:0] raddress,
    input wire [31:0] waddress,

    // data in/out
    input wire [31:0] data_in,
    output wire [31:0] data_out,

     // true if writing, false if reading
     input wire write,

     // clock
     input wire clk       
    );

    wire [15:0]readUsefullAddress = raddress[15:0]; 
    
    wire [15:0]addS0 = readUsefullAddress + 0;
    wire [15:0]addS1 = readUsefullAddress + 1;
    wire [15:0]addS2 = readUsefullAddress + 2;
    wire [15:0]addS3 = readUsefullAddress + 3;
    
    
    wire [15:0]writeUsefullAddress = waddress[15:0]; 
    
    wire [15:0]waddS0 = writeUsefullAddress + 0;
    wire [15:0]waddS1 = writeUsefullAddress + 1;
    wire [15:0]waddS2 = writeUsefullAddress + 2;
    wire [15:0]waddS3 = writeUsefullAddress + 3;
        
    wire [7:0]inS0; 
    wire [7:0]inS1;
    wire [7:0]inS2;
    wire [7:0]inS3;
        
    wire [7:0]outS0; 
    wire [7:0]outS1;
    wire [7:0]outS2;
    wire [7:0]outS3;
         	    
    assign data_out[31:24] = outS3;
    assign data_out[23:16] = outS2;
    assign data_out[15:8] = outS1;
    assign data_out[7:0] = outS0;
    
    assign inS3 = data_in[31:24];
    assign inS2 = data_in[23:16];
    assign inS1 = data_in[15:8];
    assign inS0 = data_in[7:0]; 
    
    //Bancos de memórias (cada banco possui 65536 bytes)
    //0
    ramOnChip #(.init_file(init_file), .ramSize(65536), .ramWide(8) ) memBlock0 (.clk(clk), .data(inS0), .radd(addS0), .wadd(waddS0), .wren(write), .q(outS0) );
    //1
    ramOnChip #(.init_file(init_file), .ramSize(65536), .ramWide(8) ) memBlock1 (.clk(clk), .data(inS1), .radd(addS1), .wadd(waddS1), .wren(write), .q(outS1) ); 
    //2
    ramOnChip #(.init_file(init_file), .ramSize(65536), .ramWide(8) ) memBlock2 (.clk(clk), .data(inS2), .radd(addS2), .wadd(waddS2), .wren(write), .q(outS2) ); 
    //3
    ramOnChip #(.init_file(init_file), .ramSize(65536), .ramWide(8) ) memBlock3 (.clk(clk), .data(inS3), .radd(addS3), .wadd(waddS3), .wren(write), .q(outS3) );
        
endmodule
    
    
    
