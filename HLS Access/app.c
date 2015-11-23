#include "app.h"

int app(data_m *DataIn, data_m *saMaster){

	#pragma HLS INTERFACE s_axilite port=DataIn bundle=BUS_A
	#pragma HLS INTERFACE s_axilite port=return bundle=BUS_A

	#pragma HLS INTERFACE m_axi depth=1 port=saMaster offset=off

	int InputRequest;
	int pointer1, pointer2;
	int EventN;
	int ReturnValue;

	InputRequest = *DataIn + 1;

	pointer1 = SysMalloc(InputRequest, saMaster);
	SysFree(pointer1,saMaster);
	pointer2 = SysMalloc(InputRequest, saMaster);


	ReturnValue = pointer1  + pointer2;
	return ReturnValue;
}

volatile int SysMalloc(data_m size, data_m *saMaster){

	int token = 0, status = 0, result = 0;

	while(token == 0){
    	token = saMaster[(MMU_BASE + MMU_TOKEN)/4];
	}

	saMaster[(MMU_BASE+ MMU_CMD)/4] = size;


	while(status == 0){
		status = saMaster[(MMU_BASE+ MMU_STATUS)/4];
	}

	result = saMaster[(MMU_BASE+ MMU_RESULT)/4];

	return result;

}

volatile void SysFree(data_m addr, data_m *saMaster){

	int token = 0, status = 0, result = 0;

	while(token == 0){
    	token = saMaster[(MMU_BASE + MMU_TOKEN)/4];
	}

	saMaster[(MMU_BASE+ MMU_FREE)/4] = addr;

	while(status == 0){
		status = saMaster[(MMU_BASE+ MMU_STATUS)/4];
	}

	result = saMaster[(MMU_BASE+ MMU_RESULT)/4];
}
