//Myra Murray - Constraints for Elevator Project

set_property PACKAGE_PIN J1 [get_ports clk] 
    set_property IOSTANDARD LVCMOS33 [get_ports clk] 
    set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets clk_IBUF] 
 
# Switches
set_property PACKAGE_PIN V17 [get_ports {FLRSW[0]}]					
  set_property IOSTANDARD LVCMOS33 [get_ports {FLRSW[0]}]
set_property PACKAGE_PIN V16 [get_ports {FLRSW[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {FLRSW[1]}]
set_property PACKAGE_PIN W16 [get_ports {FLRSW[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {FLRSW[2]}]
set_property PACKAGE_PIN W17 [get_ports {FLRSW[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {FLRSW[3]}]

	
#LEDS
set_property PACKAGE_PIN L1 [get_ports {ATFLR[3]}]                               
      set_property IOSTANDARD LVCMOS33 [get_ports {ATFLR[3]}]
set_property PACKAGE_PIN P1 [get_ports {ATFLR[2]}]                            
      set_property IOSTANDARD LVCMOS33 [get_ports {ATFLR[2]}]
set_property PACKAGE_PIN N3 [get_ports {ATFLR[1]}]                            
      set_property IOSTANDARD LVCMOS33 [get_ports {ATFLR[1]}]
set_property PACKAGE_PIN P3 [get_ports {ATFLR[0]}]                            
      set_property IOSTANDARD LVCMOS33 [get_ports {ATFLR[0]}]