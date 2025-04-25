///////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////Driver////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////


class Radwa_driver extends uvm_driver #(Radwa_sequence_item);

	`uvm_component_utils (Radwa_driver)
	Radwa_sequence_item Rad_seq_item;
    
	virtual INTF_UART U_intf;
   
    function new (string name, uvm_component parent);
		super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		Rad_seq_item = Radwa_sequence_item::type_id::create("Rad_seq_item");
		$display("build phase of driver");
    //////////////////////////// set & get ////////////////////////////////////
		if(!uvm_config_db#(virtual INTF_UART)::get(this, "", "my_vif", U_intf)) $fatal("Failed to get my_vif0");
    endfunction

    function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		$display("connect phase of driver");
    endfunction

    task run_phase(uvm_phase phase);
		super.run_phase(phase);
		$display("run phase of driver");
		
		forever
			begin
				if(Rad_seq_item.RST == 1)  //to not stuck at this line @(posedge U_intf.TX_CLK)
					begin
						seq_item_port.get_next_item(Rad_seq_item);
						@(posedge U_intf.TX_CLK)
						begin
						U_intf.RX_IN <= Rad_seq_item.RX_IN;
						U_intf.RST   <= Rad_seq_item.RST;
						end
						seq_item_port.item_done();
					end
				else 
					begin
						seq_item_port.get_next_item(Rad_seq_item);
						@(posedge U_intf.UART_CLK)
						U_intf.RST   <= Rad_seq_item.RST;
						seq_item_port.item_done();
					end		
			end
	endtask
endclass
