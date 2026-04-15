module spi_slave(
    input sclk,
    input rst,
    input cs,
    input [7:0] tx_data,
    input mosi,
    output reg miso,
    output reg [7:0] rx_data,
    output reg done
);

reg [7:0] shift_tx;
reg [7:0] shift_rx;
reg [2:0] bit_count;

always@(negedge cs or posedge rst) begin
    if(rst) begin
        miso<=0;
        rx_data<=8'd0;
        done<=0;
        shift_tx<=8'd0;
        shift_rx<=8'd0;
        bit_count<=3'd0;
    end
    else begin
        shift_tx<=tx_data;
        shift_rx<=8'd0;
        bit_count<=3'd0;
        miso<=tx_data[7]; //first bit_count
        done<=0;
    end
end

always@(posedge sclk or posedge rst) begin
//samples MOSI on rising edge
    if(rst) begin
    shift_rx<=8'd0;
    end
    else if(!cs) begin
        shift_rx<={shift_rx[6:0],mosi};

        if(bit_count==3'd7) begin
        rx_data<={shift_rx[6:0],mosi};
        done<=1;
        end
    end
end

//on falling edge of sclk, change MISO
always@(negedge sclk or posedge rst) begin
    if(rst) begin
    shift_tx<=8'd0;
    bit_count<=3'd0;
    miso<=0;
    end
    else if(!cs) begin
        shift_tx<={shift_tx[6:0],1'b0};
        miso<=shift_tx[6];

        bit_count<=bit_count+1;
    end
end

endmodule