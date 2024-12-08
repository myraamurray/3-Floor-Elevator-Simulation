//Myra Murray - Verilog for Elevator Project 

module main(FLRSW, clk, ATFLR);    
    input clk;
    input [3:0] FLRSW; //Switches ("Floor Switch 1", "Floor Switch 2", "Floor Switch 3"...
    output reg [3:0] ATFLR; //LEDS ("At Floor 1", "At Floor 2", "At Floor 3"...
	reg [3:0] floor=4'b0000, next_floor; //Next and current states for assignment clock => "Arriving" floor used for making sure two clock cycles used


parameter  SFLOOR1a= 4'b0000, SFLOOR1o= 4'b0001, SFLOOR1c= 4'b0010, SFLOOR2a= 4'b0011, SFLOOR2o= 4'b0100; //Parameters for states
parameter  SFLOOR2c= 4'b0101, SFLOOR3a= 4'b0110, SFLOOR3o= 4'b0111, SFLOOR3c= 4'b1000, SFLOOR13= 4'b1001, SFLOOR31= 4'b1010; //Parameters for states

always@(floor)
    casex(floor)
        SFLOOR13: next_floor <= SFLOOR3a; //Case assignment for going from floor 1 to 3 (transitionary floor) => To make sure the elevator passes through 2nd floor
        SFLOOR31: next_floor <= SFLOOR1a; //Case assignment for going from floor 3 to 1 (transitionary floor) => To make sure the elevator passes through 2nd floor

        SFLOOR1a: next_floor <= SFLOOR1o; //Assignment for first floor arriving => necessary to ensure that it takes 2 clock cycles to move
        SFLOOR1o: casex(FLRSW) //Assignments for first floor w/ door open 
					4'b1xxx: next_floor <= SFLOOR1o; //If door blocked, stay at first floor with door open 
                   			4'b0xx1: next_floor <= SFLOOR1c; //If first floor is called while on first floor, simply close the door  
					4'b0x10: next_floor <= SFLOOR2a; //If the second floor is called, go to 2a (2nd floor arrival state)
					4'b0100: next_floor <= SFLOOR13; //If the third floor is called, go to the transition floor for 1 => 3
					4'b0000:next_floor <= SFLOOR1c; //If no input, simply close the door 
					default:  next_floor <= 4'bxxxx; //Default for other unexpected situations
				endcase
		SFLOOR1c: casex(FLRSW) //Assignments for first floor w/ door closed 
					4'b1xxx: next_floor <= SFLOOR1o; //Door blocked => stay open 
                    			4'b0xx1: next_floor <= SFLOOR1c; //First floor called => keep door closed
					4'b0x10: next_floor <= SFLOOR2a; //Second door called => go to 2 arrival 
					4'b0100: next_floor <= SFLOOR13; //Third floor called while on third floor => go to 1-3 transition floor 
					4'b0000:next_floor <= SFLOOR1c; //No input => keep door closed
					default:  next_floor <= 4'bxxxx;
				endcase

		SFLOOR2a: next_floor <= SFLOOR2o; //Assignment for second floor arriving
		SFLOOR2o:casex(FLRSW) //Assignments for second floor door open. Follows same logic as first floor (minus 1-3 transition state)
					4'b1xxx: next_floor <= SFLOOR2o; 
					4'b0x1x: next_floor <= SFLOOR2c;
					4'b0x01: next_floor <= SFLOOR1a;
					4'b0000: next_floor <= SFLOOR2c;
					4'b0100: next_floor <= SFLOOR3a; 
					default: next_floor <= 4'bxxxx;
                		endcase     
		SFLOOR2c: casex(FLRSW) //Assignment for second floor with door closed. Follows the same logic as first floor door closed (minus 1-3 transition state)
					4'b1xxx: next_floor <= SFLOOR2o;
					4'b0x1x: next_floor <= SFLOOR2c;
					4'b0x01: next_floor <= SFLOOR1a;
					4'b0000: next_floor <= SFLOOR2c;
					4'b0100: next_floor <= SFLOOR3a; 
					default: next_floor <= 4'bxxxx;  
				endcase  

		SFLOOR3a: next_floor <= SFLOOR3o; //Assignment for arriving at the third floor 
		SFLOOR3o: casex(FLRSW) //Assignment for second floor with door open. Follows the same logic as first floor door, except its transition state is called Floor31
					4'b1xxx:  next_floor <= SFLOOR3o;
					4'b01xx: next_floor<= SFLOOR3c;
					4'b001x: next_floor <= SFLOOR2a;
					4'b0000: next_floor <= SFLOOR3c;
					4'b0001: next_floor <= SFLOOR31; //If first floor called, go to transition for 3 => 1
					default: next_floor <= 4'bxxxx;
				endcase
		SFLOOR3c:casex(FLRSW) //Assignment for third floor with door closed. Follows the same logic as first floor door closed, except its transition state is called Floor31
				    	4'b1xxx:  next_floor <= SFLOOR3o;
					4'b01xx: next_floor<= SFLOOR3c;
					4'b001x: next_floor <= SFLOOR2a;
					4'b0000: next_floor <= SFLOOR3c;
					4'b0001: next_floor <= SFLOOR31;
					default: next_floor <= 4'bxxxx;
			endcase
		default: next_floor<=4'bxxxx; //Default for nested always
    endcase

always@(posedge clk) //Clock transition
    floor <= next_floor;
    
always@(floor) //Assignments for LED lights => 4'bxxxx => each x corresponds to an LED  
    case(floor) 
        SFLOOR1a: ATFLR = 4'b1001; //ex. First and last bits are 1 => First (door open) and last (first floor) LEDs are on
        SFLOOR1o: ATFLR = 4'b1001; //First floor door open
        SFLOOR1c: ATFLR = 4'b0001; //First floor door closed => same procedure for the rest of the outputs => leftmost bit corresponds to door open/closed, next bit is 3rd floor, etc
        SFLOOR2a: ATFLR = 4'b1010; 
        SFLOOR2o: ATFLR = 4'b1010;
        SFLOOR2c: ATFLR = 4'b0010;
        SFLOOR3a: ATFLR = 4'b1100; 
        SFLOOR3o: ATFLR = 4'b1100;
        SFLOOR3c: ATFLR = 4'b0100;
        SFLOOR13: ATFLR = 4'b0010;
        SFLOOR31: ATFLR = 4'b0010;
        default: ATFLR  = 4'bxxxx;
    endcase
endmodule