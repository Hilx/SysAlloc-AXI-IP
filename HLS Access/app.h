#ifndef APP_H_
#define APP_H_

#include <stdio.h>
#include <string.h>

#define MMU_BASE 0x43C00000
#define MMU_TOKEN 0
#define MMU_STATUS 4
#define MMU_RESULT 8
#define MMU_CMD 12
#define MMU_FREE 16

typedef volatile int data_m;

int app(data_m *DataIn, data_m *SAMaster);
volatile int SysMalloc(data_m size, data_m *MasterPort);
volatile void SysFree(data_m addr, data_m *saMaster);

#endif
