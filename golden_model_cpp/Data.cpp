#include <iostream>
#include<fstream>
#include <string> 
#include <vector>
using namespace std;

//////////////////////////////////////function to calc the correct values//////////////////////////////
short int ALU_CHECK (int num1, int num2, int func)
	{
		short int result = 0;
		
		switch (func) 
			{
			case 0x0:
				result = num1 + num2;
				cout<<"The Result = "<< num1 << " + " << num2 << " = 0x" << hex << result << endl;
				break;
				
			case 0x1:
				result = num1 - num2;
				cout<<"The Result = "<< num1 << " - " << num2 << " = 0x" << hex << result << endl;
				break;
				
			case 0x2:
				result = num1 * num2;
				cout<<"The Result = "<< num1 << " * " << num2 << " = 0x" << hex << result << endl;
				break;
				
			case 0x3:
				result = num1 / num2;
				cout<<"The Result = "<< num1 << " / " << num2 << " = 0x" << hex << result << endl;
				break;
				
			case 0x4:
				result = num1 & num2;
				cout<<"The Result = "<< num1 << " AND " << num2 << " = 0x" << hex << result << endl;
				break;
				
			case 0x5:
				result = num1 | num2;
				cout<<"The Result = "<< num1 << " OR " << num2 << " = 0x" << hex << result << endl;
				break;
				
			case 0x6:
				result = ~(num1 & num2);
				cout<<"The Result = "<< num1 << " NAND " << num2 << " = 0x" << hex << result << endl;
				break;
				
			case 0x7:
				result = ~(num1 | num2);
				cout<<"The Result = "<< num1 << " NOR " << num2 << " = 0x" << hex << result << endl;
				break;
				
			case 0x8:
				result = num1 ^ num2;
				cout<<"The Result = "<< num1 << " XOR " << num2 << " = 0x" << hex << result << endl;
				break;
				
			case 0x9:
				result = ~(num1 ^ num2);
				cout<<"The Result = "<< num1 << " XNOR " << num2 << " = 0x" << hex << result << endl;
				break;
				
			case 0xA:
				result = (num1 == num2)?(1):(0);
				if (result == 1) 
					cout<< num1 << " = " << num2 << endl;
				else
					cout<< num1 << " != " << num2 << endl;
				break;
				
			case 0xB:
				result = (num1 > num2)?(2):(0);
				if (result == 2) 
					cout<< num1 << " > " << num2 << endl;
				else
					cout<< num1 << " < " << num2 << endl;
				break;
				
			case 0xC:
				result = (num1 < num2)?(3):(0);
				if (result == 3) 
					cout<< num1 << " < " << num2 << endl;
				else
					cout<< num1 << " > " << num2 << endl;
				break;
				
			case 0xD:
				result = num1 >> 1;
				cout<<"The Result of shift right for OP_A = "<< result <<endl;
				break;
				
			case 0xE:
				result = num1 << 1;
				cout<<"The Result of shift left for OP_B = "<< result <<endl;
				break;
				
			default:
				cout << "Function is unknown" << endl;
				result = 0xabcd;
				
			}
		return result;
	}

	extern "C" short int process_data(const short int data[4]) {
    /////////////////////////////read randomization values from the file/////////////////////////////
    std::cout << "Hi I am Radwa"<<endl;
		
	
	////////////////////////////////////////////extract values and dividing it/////////////////
	///////////////////////////////////////////Also write the correct Values in a file/////////
	short int OP_A = 0;
	short int OP_B = 0;
	short int ALU_FUNC;
	short int Address;
	short int Read_Data;
	short int Result = 0;
	//unsigned int high_byte;
	//unsigned int low_byte;
	 static vector<short int> Reg_file(16, 0); // Corrected: 16 entries (0-15)

    // Initialize Reg_file with some values
    //Reg_file[2] = 65;
    Reg_file[3] = 1;
	
			switch (data[0])			
			{
			case 0xAA:
				cout << "The Command is (0xAA): " << data[0] << endl;
				Address = data[1];
				cout << "The Write Address: " << Address << endl;
                Reg_file[Address] = data[2];
                cout << "The Write Data: " << Reg_file[Address] << endl;
				Result = Reg_file [Address];
				break;
				
			case 0xBB:
				cout << "The Command is (0xBB): " << data[0] << endl;
				Address = data[1];
				Read_Data = Reg_file [Address];
				cout << "The Read Data: "<< Reg_file [Address] << endl;
				Result = Reg_file [Address];
				break;
				
			case 0xCC:
				cout << "The Command is (0xCC): "<< data[0] << endl;

				OP_A = data[1];
				cout << "The Operator A: "<< OP_A << endl;
				Reg_file [0] = OP_A;
				OP_B = data[2];
				cout << "The Operator B: "<< OP_B << endl;
				Reg_file [1] = OP_B;
				ALU_FUNC = data[3];
				cout << "The ALU Function: "<< ALU_FUNC << endl;
				
				/////////caling the function
				Result = ALU_CHECK(OP_A, OP_B, ALU_FUNC);
				//low_byte  = ALU_Frame & 0xFF;         // lower 8 bits
				//high_byte = (ALU_Frame >> 8) & 0xFF;  // upper 8 bits
				break;
				
			case 0xDD:
				cout << "The Command is (0xDD): "<< data[0] << endl;
				OP_A = Reg_file [0];
				cout << "The Operator A: "<< OP_A << endl;
				OP_B = Reg_file [1];
				cout << "The Operator B: "<< OP_B << endl;
				ALU_FUNC = data[1];
				cout << "The ALU Function: "<< ALU_FUNC << endl;
				
				/////////caling the function
				Result = ALU_CHECK(OP_A, OP_B, ALU_FUNC);
				//low_byte  = ALU_Frame & 0xFF;         // lower 8 bits
				//high_byte = (ALU_Frame >> 8) & 0xFF;  // upper 8 bits
				break;
				
			default:
				cout << "Number is unknown" << endl;
				cout << "data[0] of the aar is: "<< data[0] << endl;
				cout << "data[1] of the aar is: "<< data[1] << endl;
				cout << "data[2] of the aar is: "<< data[2] << endl;
				cout << "data[3] of the aar is: "<< data[3] << endl;
				
			}

    return Result;
	
	
}
/////Checking the functionality
int main() {
	short int arr[4] = {204, 20, 158, 14};
    short int result;

    result = process_data(arr);
    cout << "The Result = " << result << endl;
	
	short int arr2 [4] = {221, 1, 0, 0};
	result = process_data(arr2);
	cout << "The Result 2 = " << result << endl;
	
	short int arr3 [4] = {170, 2, 131, 0};
	result = process_data(arr3);
	cout << "The Result 3 = " << result << endl;
	
	short int arr4 [4] = {187, 2, 0, 0};
	result = process_data(arr4);
	cout << "The Result 4 = " << result << endl;
		
		return 0;
	}
