# PMOD.1  tri_pulse_A
# PMOD.2  tri_pulse_B
# PMOD.3  tri_pulse_C
# PMOD.4  Run
# PMOD.5  DGND
# PMOD.6  VCC
# PMOD.7  NC
# PMOD.8  NC
# PMOD.9  NC
# PMOD.10 RunStatus
set_property -dict {PACKAGE_PIN G17 IOSTANDARD LVCMOS33} [get_ports tri_pulse_A]
set_property -dict {PACKAGE_PIN G19 IOSTANDARD LVCMOS33} [get_ports tri_pulse_B]
set_property -dict {PACKAGE_PIN N18 IOSTANDARD LVCMOS33} [get_ports tri_pulse_C]
set_property -dict {PACKAGE_PIN L18 IOSTANDARD LVCMOS33} [get_ports Run]
set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS33 PULLDOWN true} [get_ports RunStatus]
set_property -dict {PACKAGE_PIN A17 IOSTANDARD LVCMOS33} [get_ports {leds[0]} ]
set_property -dict {PACKAGE_PIN C16 IOSTANDARD LVCMOS33} [get_ports {leds[1]} ]


set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
