///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////Subscriber//////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////

  `uvm_analysis_imp_decl(_IN)
  `uvm_analysis_imp_decl(_OUT)


class Radwa_subscriber extends uvm_subscriber #(Radwa_sequence_item);

  `uvm_component_utils (Radwa_subscriber)
  

  
  //////////////////tlm
  Radwa_sequence_item Rad_seq_item;
  uvm_analysis_imp_IN #(Radwa_sequence_item, Radwa_subscriber) analysis_imp_A;
  uvm_analysis_imp_OUT #(Radwa_sequence_item, Radwa_subscriber) analysis_imp_B;

//////////////////////////////////////////////Cover Group//////////////////////////////////////////////////////
	
	covergroup group1;
		coverpoint Rad_seq_item.RST       	{bins RST_1 [] = {0, 1};}
		coverpoint Rad_seq_item.TX_OUT    	{bins bin_3 [] = {0, 1};}
		coverpoint Rad_seq_item.P_Data  	{bins bin_5 [] = {[8'b0000:8'b1110]};}
		coverpoint Rad_seq_item.P_Data	 	{bins bin_8 [] = {['d0:'d15]};}
		coverpoint Rad_seq_item.P_Data 		{bins bin_10[] = {'h00, ['h01:'hFE], 'hFF};}
		coverpoint Rad_seq_item.P_Data		{bins bin_11[] = {'h83, 'h80, 'h41, 'h43, 'h40, 'h21, 'h23, 'h20};}
	endgroup
	
////////////////////////////////////////////////////new//////////////////////////////////////////////////////
	function new (string name, uvm_component parent);
		super.new(name, parent);
		/////////////coverage
		group1 = new();
		///////////////tlm
		analysis_imp_A = new("analysis_imp_A", this);
		analysis_imp_B = new("analysis_imp_B", this);
	endfunction

////////////////////////////////////////////build_phase///////////////////////////////////////////////////////
	function void build_phase(uvm_phase phase);
       super.build_phase(phase);
	   Rad_seq_item = Radwa_sequence_item::type_id::create("Rad_seq_item", this);
       $display("build phase of subscriber");
    endfunction


///////////////////////////////////////////connect_phase//////////////////////////////////////////////////////
    function void connect_phase(uvm_phase phase);
       super.connect_phase(phase);
       $display("connect phase of subscriber");
    endfunction


////////////////////////////////////////////////run_test//////////////////////////////////////////////////////
    task run_phase(uvm_phase phase);
       super.run_phase(phase);
       $display("run phase of subscriber");
	   
    endtask
  
///////////////////////////////////pure virtual function write////////////////////////////////////////////////

	function void write_IN(Radwa_sequence_item t);
		Rad_seq_item = t;
		Rad_seq_item.copy(t);
		group1.sample();
		$display("/////////////////////////////////////////////////////////////////////From subscriber the coverage = ", group1.get_inst_coverage());
	endfunction
	
	function void write_OUT(Radwa_sequence_item t);
		Rad_seq_item = t;
		group1.sample();
		$display("////////////////////////////////////////////////////////////////////////////////////Received from Monitor_OUT: %p", t.P_Data);
		$display("/////////////////////////////////////////////////////////////////////From subscriber the coverage = ", group1.get_inst_coverage());
	endfunction
	
	function void write(Radwa_sequence_item t);
		$display("I am Empty");
	endfunction

endclass
