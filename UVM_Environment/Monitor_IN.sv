///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////monitor/////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
class Radwa_monitor_in extends uvm_monitor;

    `uvm_component_utils (Radwa_monitor_in)
	
	virtual INTF_UART U_intf;
	
	////////////tlm//////////////////
	Radwa_sequence_item Rad_seq_item2;
	uvm_analysis_port #(Radwa_sequence_item) analysis_port_IN;

    function new (string name, uvm_component parent);
		super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	//////////////////////////// get ////////////////////////////////////
		if(!uvm_config_db#(virtual INTF_UART)::get(this, "", "my_vif", U_intf)) $fatal("Failed to get my_vif1");
	   
	///////////////////tlm///////////
		analysis_port_IN = new ("analysis_port_IN", this);
	   
		Rad_seq_item2 = Radwa_sequence_item::type_id::create("Rad_seq_item2");
		$display("build phase of monitor 2");
    endfunction

    function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		$display("connect phase of monitor 2");
    endfunction

    task run_phase(uvm_phase phase);
		super.run_phase(phase);
		$display("run phase of monitor 2");
		
		forever
			begin
			@(negedge U_intf.TX_CLK)
			@(negedge U_intf.RX_Valid)
				begin
					Rad_seq_item2.P_Data <= U_intf.P_Data;
					analysis_port_IN.write(Rad_seq_item2);
					$display("From monitor_IN P_Data (U_intf.P_Data) = %h ", U_intf.P_Data);
				end
							
			end
	   
    endtask
	
endclass

