/********************************************************************
 * Model of RAM Memory - Verilog Training Course.
 *********************************************************************/

`timescale 1ns / 1ns

module mem(data,
           addr,
           read,
           write);
    inout [7:0] data;
    input [4:0] addr;
    input       read, write;

    reg[7:0] mem[0:7] ;

    wire[7:0] mem_out;

    integer i;

    //Memory Blocks
    always @(posedge write)
    begin
        if (write)
            mem[addr] <= data;
        else
            mem[addr] <= mem[addr];
    end

    //read
    assign data = read ? mem[addr] : 'dz;


endmodule
