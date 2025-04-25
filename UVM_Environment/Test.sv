
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////Test//////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////

class Test extends uvm_test;

    `uvm_component_utils (Test)
	
    Radwa_env my_env;
	Radwa_Sequence Rad_sequence;
	
	virtual INTF_UART U_intf;
	
	///set uvm event in the class contains the sequence and TX_Monitor
	uvm_event monitor_done_event;

////////////////////////////////////////////////new///////////////////////////////////////////////////////////
	function new (string name, uvm_component parent);
		super.new(name, parent);
	endfunction

//////////////////////////////build_phase/////////////////////////////////////////////////////////////////////
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		my_env = Radwa_env::type_id::create("my_env", this);
		Rad_sequence = Radwa_Sequence::type_id::create("Rad_sequence");
	   
		//////////////////////////// set & get
		if(!uvm_config_db#(virtual INTF_UART)::get(this, "", "my_vif", U_intf)) $fatal("Failed to get my_vif4");
		uvm_config_db#(virtual INTF_UART)::set(this, "*", "my_vif", U_intf);
	   
		///set uvm event in the class contains the sequence and TX_Monitor
		monitor_done_event = new("monitor_done_event");
		uvm_config_db#(uvm_event)::set(this, "*", "monitor_done_event", monitor_done_event);
	   	   
		$display("build phase of Test");
    endfunction

///////////////////////////////////////connect_phase//////////////////////////////////////////////////////////
    function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		$display("connect phase of Test");

    endfunction

///////////////////////////////////////////run_phase//////////////////////////////////////////////////////////
    task run_phase(uvm_phase phase);
		super.run_phase(phase);
		$display("run phase of Test");
	    
		phase.raise_objection(this);
		Rad_sequence.start(my_env.Rad_agent.Rad_seq);
		phase.drop_objection(this);
    endtask

endclass
