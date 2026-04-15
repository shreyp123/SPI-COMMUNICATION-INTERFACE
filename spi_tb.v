`timescale 1ns / 1ps

module spi_tb;
reg clk,rst;
reg start;
reg [7:0] m_tx;
reg [7:0] s_tx;

wire [7:0] m_rx;
wire [7:0] s_rx;
wire miso;
wire mosi;
wire sclk;
wire cs;
wire m_done;
wire s_done;

//Instance of master
spi_master dut_m(clk,rst,start,miso,m_tx,sclk,mosi,cs,m_rx,m_done);

//Instance of slave
spi_slave dut_s(sclk,rst,cs,s_tx,mosi,miso,s_rx,s_done);

always #5 clk=~clk;

initial begin 
clk=0;
rst=1;
start=0;
m_tx=8'h0;
s_tx=8'h0;

#20;
rst=0;

m_tx=8'hA5;
s_tx=8'h3C;

#10;
start=1;

#10;
start=0;

wait(m_done);
#20;
        $display("Master Sent     = %h", m_tx);
        $display("Slave Received  = %h", s_rx);
        $display("Slave Sent      = %h", s_tx);
        $display("Master Received = %h", m_rx);

        if ((s_rx == m_tx) && (m_rx == s_tx))
            $display("SPI TEST PASSED");
        else
            $display("SPI TEST FAILED");

        #20;
        $finish;
end

endmodule