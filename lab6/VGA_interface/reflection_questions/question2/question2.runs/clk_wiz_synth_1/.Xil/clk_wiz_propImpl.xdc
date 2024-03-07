set_property SRC_FILE_INFO {cfile:c:/Vivadolabs/lab6/VGA_interface/reflection_questions/question2/question2.gen/sources_1/ip/clk_wiz/clk_wiz.xdc rfile:../../../question2.gen/sources_1/ip/clk_wiz/clk_wiz.xdc id:1 order:EARLY scoped_inst:inst} [current_design]
current_instance inst
set_property src_info {type:SCOPED_XDC file:1 line:57 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter [get_clocks -of_objects [get_ports clk_in1]] 0.1
