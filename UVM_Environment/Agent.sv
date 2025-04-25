///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////Agent///////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////

class Radwa_agent extends uvm_agent;

  `uvm_component_utils (Radwa_agent)

  Radwa_driver Rad_driv;
  Radwa_monitor Rad_mon;
  Sequencer Rad_seq;
  
  ///////////tlm
  uvm_analysis_port #(Radwa_sequence_item) My_analysis_port;
  
  virtual INTF_UART U_intf;
///////////////////////////////////////////////////new/////////////////////////////////////////////////////////
  function new (string name, uvm_component parent);
     super.new(name, parent);
  endfunction

//////////////////////////////////////////////build_phase//////////////////////////////////////////////////////
      function void build_phase(uvm_phase phase);
		super.build_phase(phase);
   
		Rad_driv = Radwa_driver::type_id::create("Rad_driv", this);
		Rad_mon  = Radwa_monitor::type_id::create("Rad_mon", this);
		Rad_seq  = Sequencer::type_id::create("Rad_seq", this);
		My_analysis_port = new("My_analysis_port", this);

       $display("build phase of agent");
    endfunction

/////////////////////////////////////////////connect_phase/////////////////////////////////////////////////////
    function void connect_phase(uvm_phase phase);
       super.connect_phase(phase);
	   
	   /////////////tlm
	   Rad_mon.analysis_port_OUT.connect(My_analysis_port);
	   Rad_driv.seq_item_port.connect(Rad_seq.seq_item_export);
	   
       $display("connect phase of agent");
    endfunction

///////////////////////////////////////////////run_phase///////////////////////////////////////////////////////
    task run_phase(uvm_phase phase);
       super.run_phase(phase);
       $display("run phase of agent");
    endtask

endclass
