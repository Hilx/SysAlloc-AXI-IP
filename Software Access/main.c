#include <stdio.h>
#include "platform.h"

#define MMU_BASE 0x43C00000 // change this to your SysAlloc base address
#define MMU_TOKEN 0
#define MMU_STATUS 4
#define MMU_RESULT 8
#define MMU_CMD 12
#define MMU_FREE 16

void print(char *str);

int hw_malloc(int address);
void hw_mfree(int address);
void init_ddr(void);

int main()
{
	int my_addr;
	
    init_platform();

	print("What's up World!\n");
	
	/* to set up the empty allocation tree */
    init_ddr(); 
    init_ddr();

	my_addr = hw_malloc(1000); //malloc
	
	print("Allocated memory address is ");
    putnum(result);
	
	hw_mfree(my_addr);//mfree   

	return 0;
}


int hw_malloc(int size){
	int token,status,result;
    token = 0;
    status = 0;

	// acquiring token
	while(token == 0){
		token =  Xil_In32(MMU_BASE + MMU_TOKEN);
	}
	
	// write request
	Xil_Out32(MMU_BASE + MMU_CMD, size);

	// checking allocation status
	while(status == 0){
    	status =  Xil_In32(MMU_BASE + MMU_STATUS);
	}
	
	//read result back
    result = Xil_In32(MMU_BASE + MMU_RESULT);

    return result;
}

void hw_mfree(int address){

	int token,status,result;
    token = 0;
    status = 0;

	// acquiring token 
	while(token == 0){
		token =  Xil_In32(MMU_BASE + MMU_TOKEN);
	}

	// write request
	Xil_Out32(MMU_BASE + MMU_FREE, address);

	// checking de-allocation status
	while(status == 0){
    	status =  Xil_In32(MMU_BASE + MMU_STATUS);
	}

	// performing a READ to reset token
    result = Xil_In32(MMU_BASE + MMU_RESULT);
}

void init_ddr(void){
	int i;
	for(i = 0; i <2396745; i++)
		Xil_Out32(0x18000000 + 4*i, 0);

}