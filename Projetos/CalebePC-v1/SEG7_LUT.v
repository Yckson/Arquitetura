module SEG7_LUT	(	out,in	);
input	[3:0]	in;
output	[6:0]	out;
reg		[6:0]	oSEG;


assign out = oSEG;	// output to 7-segment display

always @(in)
begin
		case(in)
		4'h1: oSEG <= 7'b1111001;	// ---t----
		4'h2: oSEG <= 7'b0100100; 	// |	  |
		4'h3: oSEG <= 7'b0110000; 	// lt	 rt
		4'h4: oSEG <= 7'b0011001; 	// |	  |
		4'h5: oSEG <= 7'b0010010; 	// ---m----
		4'h6: oSEG <= 7'b0000010; 	// |	  |
		4'h7: oSEG <= 7'b1111000; 	// lb	 rb
		4'h8: oSEG <= 7'b0000000; 	// |	  |
		4'h9: oSEG <= 7'b0011000; 	// ---b----
		4'ha: oSEG <= 7'b0001000;
		4'hb: oSEG <= 7'b0000011;
		4'hc: oSEG <= 7'b1000110;
		4'hd: oSEG <= 7'b0100001;
		4'he: oSEG <= 7'b0000110;
		4'hf: oSEG <= 7'b0001110;
		4'h0: oSEG <= 7'b1000000;
		endcase
end

endmodule
