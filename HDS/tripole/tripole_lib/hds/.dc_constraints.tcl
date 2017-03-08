#
# DesignChecker code/rule exclusions for library 'tripole_lib'
#
# Created:
#          by - nort.UNKNOWN (NORT-XPS14)
#          at - 16:55:18 03/ 1/2017
#
# using Mentor Graphics HDL Designer(TM) 2016.1 (Build 8)
#
dc_exclude -design_unit {syscon} -check {RuleSets\Essentials\Downstream Checks\Non Synthesizable Constructs}
dc_exclude -source_file {C:\Users\nort.ARP\Documents\Exp\PTR3S\PTR3Stripole\HDS\tripole\tripole_lib\hdl\tri_per_stat_beh.vhdl} -start_line 52 -end_line 52 -check {RuleSets\Essentials\Downstream Checks\Register Reset Control} -comment {OK}
dc_exclude -source_file {C:\Users\nort.ARP\Documents\Exp\PTR3S\PTR3Stripole\HDS\tripole\tripole_lib\hdl\tri_lvl_b_struct.vhd} -start_line 77 -end_line 77 -check {RuleSets\Essentials\Downstream Checks\Initialization Assignments} -comment {OK}
dc_exclude -source_file {C:\Users\nort.ARP\Documents\Exp\PTR3S\PTR3Stripole\HDS\tripole\tripole_lib\hdl\syscon_arch.vhdl} -start_line 206 -end_line 206 -check {RuleSets\Essentials\Downstream Checks\Register Reset Control} -comment {OK}
dc_exclude -source_file {C:\Users\nort.ARP\Documents\Exp\PTR3S\PTR3Stripole\HDS\tripole\tripole_lib\hdl\tri_per_stat_beh.vhdl} -start_line 38 -end_line 38 -check {RuleSets\Essentials\Downstream Checks\Register Controllability} -comment {OK}
dc_exclude -design_unit {tri_lvl_b} -check {RuleSets\Essentials\Code Reuse\Vector Order} -comment {OK}
dc_exclude -source_file {C:\Users\nort.ARP\Documents\Exp\PTR3S\PTR3Stripole\HDS\tripole\tripole_lib\hdl\tri_lvl_b_struct.vhd} -start_line 88 -end_line 88 -check {RuleSets\Essentials\Coding Practices\Unused Declarations} -comment {OK		}
dc_exclude -source_file {C:\Users\nort.ARP\Documents\Exp\PTR3S\PTR3Stripole\HDS\tripole\tripole_lib\hdl\tri_per_ctrl_fsm.vhd} -start_line 22 -end_line 22 -check {RuleSets\Essentials\Coding Practices\Unused Declarations} -comment {OK}
dc_exclude -source_file {C:\Users\nort.ARP\Documents\Exp\PTR3S\PTR3Stripole\HDS\tripole\tripole_lib\hdl\syscon_arch.vhdl} -start_line 338 -end_line 338 -check {RuleSets\Essentials\Downstream Checks\Register Reset Control} -comment {OK}
dc_exclude -source_file {C:\Users\nort.ARP\Documents\Exp\PTR3S\PTR3Stripole\HDS\tripole\tripole_lib\hdl\syscon_arch.vhdl} -start_line 58 -end_line 58 -check {RuleSets\Essentials\Coding Practices\Unused Declarations} -comment {OK}
dc_exclude -source_file {C:\Users\nort.ARP\Documents\Exp\PTR3S\PTR3Stripole\HDS\tripole\tripole_lib\hdl\subbus_io_beh.vhdl} -start_line 31 -end_line 31 -check {RuleSets\Essentials\Coding Practices\Unused Declarations} -comment {OK}
