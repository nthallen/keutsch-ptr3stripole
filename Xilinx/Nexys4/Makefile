ELF=MBlaze/SDK/tripole/Debug/tripole.elf
# The Nexys4 uses a Quad SPI Flash, Spansion S25FL128S
.PHONY : all
all : tripole_nexys4.mcs
tripole_nexys4.mcs : tripole_nexys4.bit
	promgen -spi -w -p mcs -o tripole_nexys4.mcs -s 16384 -u 0 tripole_nexys4.bit
tripole_nexys4.bit : MBlaze/implementation/MBlaze.bit $(ELF)
	@echo tripole_nexys4.bit is out of date with respect to $?
	@ls -lt *.mcs *.bit $(ELF)
	@false
