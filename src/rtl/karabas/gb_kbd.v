`timescale 1ns / 1ps
`default_nettype wire

/*
 gb_kbd.v

 The buttons of the Game Boy from the USB keyboard (the 6 key codes of the HID report, KB_DAT0..5 of
 kg_mcu2) and the pads of kg_mcu2 (JOY_L / JOY_R: [1] up, [2] down, [3] left, [4] right, [5] start,
 [6] A, [7] B, [8] C, [9] X, [10] Y, [11] Z, [12] mode, 1 = pressed), ORed.

 joy = { start, select, b, a, down, up, left, right }, 1 = pressed (gb_machine):
   keyboard: arrows, X = A, Z = B, Enter = Start, Space / Backspace = Select
   pads:     d-pad, A = A, B = B, Start = Start, Mode / C / X = Select
*/

module gb_kbd (
	input  wire        clk,
	input  wire [7:0]  kb_dat0,
	input  wire [7:0]  kb_dat1,
	input  wire [7:0]  kb_dat2,
	input  wire [7:0]  kb_dat3,
	input  wire [7:0]  kb_dat4,
	input  wire [7:0]  kb_dat5,
	input  wire [12:0] joy_l,
	input  wire [12:0] joy_r,
	output reg  [7:0]  joy = 8'd0
);

function [7:0] key;
	input [7:0] k;
	begin
		key = 8'd0;
		case (k)
		8'h4F: key[0] = 1'b1;          // right
		8'h50: key[1] = 1'b1;          // left
		8'h52: key[2] = 1'b1;          // up
		8'h51: key[3] = 1'b1;          // down
		8'h1B: key[4] = 1'b1;          // X: A
		8'h1D: key[5] = 1'b1;          // Z: B
		8'h2C: key[6] = 1'b1;          // Space: Select
		8'h2A: key[6] = 1'b1;          // Backspace: Select
		8'h28: key[7] = 1'b1;          // Enter: Start
		default: ;
		endcase
	end
endfunction

function [7:0] pad;
	input [12:0] j;
	begin
		pad = { j[5], j[12] | j[8] | j[9], j[7], j[6], j[2], j[1], j[3], j[4] };
	end
endfunction

wire [7:0] kb = key(kb_dat0) | key(kb_dat1) | key(kb_dat2) | key(kb_dat3) | key(kb_dat4) | key(kb_dat5);

always @(posedge clk)
	joy <= kb | pad(joy_l) | pad(joy_r);

endmodule
