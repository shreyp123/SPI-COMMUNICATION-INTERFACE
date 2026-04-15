`timescale 1ns / 1ps

module spi_master(
    input clk,rst,
    input start,
    input miso,
    input [7:0] tx_data,
    output reg sclk,
    output reg mosi,
    output reg cs, //active low chip select
    output reg [7:0] rx_data,
    output reg done
);

reg [7:0] shift_tx;
reg [7:0] shift_rx;
reg [2:0] bit_count;
reg active;

always @(posedge clk or posedge rst) begin
if(rst) begin
    sclk<=0;
    mosi<=0;
    cs<=1;
    rx_data<=8'd0;
    done<=0;
    shift_tx<=8'd0;
    shift_rx<=8'd0;
    bit_count<=3'd0;
    active<=0;
end
else begin
    done<=0;

    if(start && !active) //active-->0 means master is idle
    begin //SPI transaction starts
        active<=1;
        cs<=0;
        sclk<=0;
        bit_count<=3'd0;
        shift_tx<=tx_data;
        shift_rx<=8'd0;
        mosi<=tx_data[7];
    end
    else if(active) begin //means master is not idle,so data is transferred/received
        sclk<=~sclk;

        if(sclk==0) begin
        //means rising edge about to happen-> sample MISO
        shift_rx<={shift_rx[6:0],miso};
        end
        else begin
        //means falling edge about to happen->update the output bit
            shift_tx<={shift_tx[6:0],1'b0};
            mosi<=shift_tx[6];
            
            bit_count<=bit_count+1;

            if(bit_count==3'd7) begin //transaction of 8-bits done
                active<=0;
                cs<=1;
                done<=1;
                rx_data<=shift_rx;
                sclk<=0;
            end 
        end
    end
end
end

endmodule