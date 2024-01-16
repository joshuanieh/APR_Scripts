#######################################################
#                                                     
#  Innovus Command Logging File                     
#  Created on Mon Dec 11 19:03:48 2023                
#                                                     
#######################################################

#@(#)CDS: Innovus v17.11-s080_1 (64bit) 08/04/2017 11:13 (Linux 2.6.18-194.el5)
#@(#)CDS: NanoRoute 17.11-s080_1 NR170721-2155/17_11-UB (database version 2.30, 390.7.1) {superthreading v1.44}
#@(#)CDS: AAE 17.11-s034 (64bit) 08/04/2017 (Linux 2.6.18-194.el5)
#@(#)CDS: CTE 17.11-s053_1 () Aug  1 2017 23:31:41 ( )
#@(#)CDS: SYNTECH 17.11-s012_1 () Jul 21 2017 02:29:12 ( )
#@(#)CDS: CPE v17.11-s095
#@(#)CDS: IQRC/TQRC 16.1.1-s215 (64bit) Thu Jul  6 20:18:10 PDT 2017 (Linux 2.6.18-194.el5)

set_global _enable_mmmc_by_default_flow      $CTE::mmmc_default
suppressMessage ENCEXT-2799
getDrawView
loadWorkspace -name Physical
win
update_constraint_mode -name func_mode -sdc_files ../Netlist/CHIP_cts.sdc 
create_ccopt_clock_tree_spec -file ./ccopt.spec
ccopt_check_and_flatten_ilms_no_restore
create_ccopt_clock_tree -name clk -source clk -no_skew_group
set_ccopt_property clock_period -pin clk 5
create_ccopt_skew_group -name clk/func_mode -sources clk -auto_sinks
set_ccopt_property include_source_latency -skew_group clk/func_mode true
set_ccopt_property extracted_from_clock_name -skew_group clk/func_mode clk
set_ccopt_property extracted_from_constraint_mode_name -skew_group clk/func_mode func_mode
set_ccopt_property extracted_from_delay_corners -skew_group clk/func_mode {Delay_Corner_max Delay_Corner_max}
check_ccopt_clock_tree_convergence
get_ccopt_property auto_design_state_for_ilms
setOptMode -fixFanoutLoad true
ccopt_design -cts
saveDesign DBS/cts
ctd_win -id ctd_window
redirect -quiet {set honorDomain [getAnalysisMode -honorClockDomains]} > /dev/null
timeDesign -postCTS -pathReports -drvReports -slackReports -numPaths 50 -prefix QR_Engine_postCTS -outDir timingReports
setOptMode -fixCap true -fixTran true -fixFanoutLoad true
optDesign -postCTS
redirect -quiet {set honorDomain [getAnalysisMode -honorClockDomains]} > /dev/null
timeDesign -postCTS -hold -pathReports -slackReports -numPaths 50 -prefix QR_Engine_postCTS -outDir timingReports
saveDesign DBS/cts
