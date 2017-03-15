# Build 9: For RFCmodBoard
# PIO.45 U7 tri_pulse_A
# PIO.44 U3 tri_pulse_B
# PIO.43 W6 tri_pulse_C
# PIO.34 W3 Run
# PIO.25  DGND
# PIO.24  VCC
# PIO.33 V2 RunStatus
set_property -dict {PACKAGE_PIN U7 IOSTANDARD LVCMOS33} [get_ports tri_pulse_A]
set_property -dict {PACKAGE_PIN U3 IOSTANDARD LVCMOS33} [get_ports tri_pulse_B]
set_property -dict {PACKAGE_PIN W6 IOSTANDARD LVCMOS33} [get_ports tri_pulse_C]
set_property -dict {PACKAGE_PIN W3 IOSTANDARD LVCMOS33} [get_ports Ilock_out]
set_property -dict {PACKAGE_PIN V2 IOSTANDARD LVCMOS33 PULLDOWN true} [get_ports Ilock_rtn]
set_property -dict {PACKAGE_PIN A17 IOSTANDARD LVCMOS33} [get_ports {leds[0]} ]
set_property -dict {PACKAGE_PIN C16 IOSTANDARD LVCMOS33} [get_ports {leds[1]} ]


set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
