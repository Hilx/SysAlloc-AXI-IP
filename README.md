SysAlloc

**As a packaged component**

The VHDL implementation of SysAlloc targeting Zynq SoC as a packaged IP is in [folder source-as-IP](https://github.com/Hilx/Memory-Allocator-IP/tree/master/source_as_IP). The packaging is done using Vivado Design Suit, however, only source code are given.

To package source code into an IP, in Vivado, Create and Package IP -> Create a new AXI4 peripheral -> Name: Allocator -> Slave Interface Type : Lite (Leave the others), and create a new Master Interface (also Lite) -> Done.

Replace the files in HDL folder with files in HLD folder in this zip file. They are AXI interface files.
Add .hdl files in SRC solders to the peripheral project and copy the source file. Make sure you group them into a library called "work".
Add existing IP to add the two BRAMs's .xci files to the project and DO NOT COPY THE SOURCE FILE.

The two BRAMs are:
1. Tree Cache BRAM
2. Tracker BRAM

To configure the SysAlloc, edit the budpack.vhd.


**Simulation**

Simulation .vhd fils for the SysAlloc without the Slave/Master interfaces is provided in folder [simulation files](https://github.com/Hilx/Memory-Allocator-IP/tree/master/simulation%20files). This set of files include a intercept.vhd which is not part of the allocator. The intercept block turns received address/size into allocator address/size. 

For allocation, an extra 4-byte word is added to the input request size because it is needed to store the size of the allocation in DDR. So the first word of the actual allocated memory is like a header. The pointer address given back to the client is the actual allocation address with a shift of 4 bytes.

**Evaluation Set-up**

FPGA client source code for SysAlloc can be found [here](https://github.com/Hilx/AXI-Peripherals/tree/master/FPGA_Client). Please note that it requires two separate BRAMs to contain patterns of allocation size and rate.
