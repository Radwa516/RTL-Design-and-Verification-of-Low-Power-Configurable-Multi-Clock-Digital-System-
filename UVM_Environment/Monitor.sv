///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////monitor/////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
class Radwa_monitor extends uvm_monitor;

    `uvm_component_utils (Radwa_monitor)
	virtual INTF_UART U_intf;
	
	uvm_event monitor_done_event;
	
	////////////tlm//////////////////
	Radwa_sequence_item Rad_seq_item1;
	uvm_analysis_port #(Radwa_sequence_item) analysis_port_OUT;

    function new (string name, uvm_component parent);
		super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	//////////////////////////// get ////////////////////////////////////
		if(!uvm_config_db#(virtual INTF_UART)::get(this, "", "my_vif", U_intf)) $fatal("Failed to get my_vif1");
		if (!uvm_config_db#(uvm_event)::get(this, "", "monitor_done_event", monitor_done_event)) $display("Failed to get monitor_done_event in monitor");
	   
	///////////////////tlm///////////
		analysis_port_OUT = new ("analysis_port_OUT", this);
	   
		Rad_seq_item1 = Radwa_sequence_item::type_id::create("Rad_seq_item1");
		$display("build phase of monitor");
    endfunction

    function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		$display("connect phase of monitor");
    endfunction

    task run_phase(uvm_phase phase);
		super.run_phase(phase);
		$display("run phase of monitor");
		
		forever
			begin
				
				if(U_intf.RST == 1'b0)
					begin
						Rad_seq_item1.RST	 <= 	U_intf.RST;
						analysis_port_OUT.write(Rad_seq_item1); 
						$display("RST IS ACTIVATED/////////////////////////////////////////////////////////////////////////////////////////////");
					end

					
				//@(posedge U_intf.TX_CLK)
				@(posedge U_intf.Busy)
				while(U_intf.Busy == 1'b1)
					begin
						@(posedge U_intf.TX_CLK)
						Rad_seq_item1.TX_OUT 	<= 	U_intf.TX_OUT;
						Rad_seq_item1.RST	 	<= 	U_intf.RST;
						Rad_seq_item1.Div_Ratio <= 	U_intf.Div_Ratio;
						analysis_port_OUT.write(Rad_seq_item1); 
							
					end
				
				if(U_intf.Busy == 1'b0)
						begin
							monitor_done_event.trigger();
							$display("monitor_done_event triggered");							
						end
						
				
						
			end
	   
    endtask
	
endclass
