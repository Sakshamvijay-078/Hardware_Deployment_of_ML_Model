/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xparameters.h"
#include "xil_io.h"
#include "xbasic_types.h"
#include <time.h>
#include "input_data.h"

// Define global timer registers for Zynq-7000
#define GLOBAL_TIMER_BASE 0xF8F00200
#define GLOBAL_TIMER_COUNTER_L  (*(volatile unsigned int *)(GLOBAL_TIMER_BASE + 0x00))
#define GLOBAL_TIMER_COUNTER_H  (*(volatile unsigned int *)(GLOBAL_TIMER_BASE + 0x04))

// Function to read the 64-bit ARM global timer
u64 get_global_timer() {
    u32 low, high, high_check;

    do {
        high = GLOBAL_TIMER_COUNTER_H;
        low = GLOBAL_TIMER_COUNTER_L;
        high_check = GLOBAL_TIMER_COUNTER_H;
    } while (high != high_check);

    return (((u64)high << 32) | low);
}

int main(){

		u32 data_out;
		u64 start_time, end_time, elapsed_cycles;
		u32 seconds, millis;


		xil_printf("\n\rStart of Linear Regression 32 bit test\n\n\r");

		start_time = get_global_timer();  // Start timer

		for (int i = 0; i < 25; i++) {
			xil_printf("Test-case %d:\n\r", i+1);
			Xil_Out32(XPAR_MYIPLINEARREGRESSION_0_S00_AXI_BASEADDR, inputs[i][0]);
			Xil_Out32(XPAR_MYIPLINEARREGRESSION_0_S00_AXI_BASEADDR+0x4, inputs[i][1]);
			Xil_Out32(XPAR_MYIPLINEARREGRESSION_0_S00_AXI_BASEADDR+0x8, inputs[i][2]);
			Xil_Out32(XPAR_MYIPLINEARREGRESSION_0_S00_AXI_BASEADDR+0xc, inputs[i][3]);
			Xil_Out32(XPAR_MYIPLINEARREGRESSION_0_S00_AXI_BASEADDR+0x10,inputs[i][4]);

			data_out = Xil_In32(XPAR_MYIPLINEARREGRESSION_0_S00_AXI_BASEADDR+0x1c);

			xil_printf("Inputs: x1=0x%08x, x2=0x%08x, x3=0x%08x, x4=0x%08x, x5=0x%08x,\n\rOutput: y=0x%08x\n\n\r",
					   inputs[i][0], inputs[i][1], inputs[i][2], inputs[i][3], inputs[i][4], data_out);
		}


		end_time = get_global_timer();  // Stop timer

		elapsed_cycles = end_time - start_time;
		seconds = elapsed_cycles / 333000000;
		millis = ((elapsed_cycles % 333000000) * 1000) / 333000000;

		xil_printf("Total execution time: %u.%03u seconds\n\r", seconds, millis);
		xil_printf("Total clock cycles: 0x%08X%08X\n\r", (u32)(elapsed_cycles >> 32), (u32)elapsed_cycles);

		xil_printf("\n\rEnd of Linear Regression 32 bit test\n\r");

		return 0;
}

