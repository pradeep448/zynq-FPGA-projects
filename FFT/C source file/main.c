#include <stdio.h>
#include "platform.h"
#include <xparameters.h>
#include "xaxidma.h"

XAxiDma axiDMA;
XAxiDma_Config *axiDMA_cfg;

//DMA Addresses
#define MEM_BASE_ADDR 0x01000000
#define TX_BUFFER_BASE (MEM_BASE_ADDR + 0x00100000) //tx buffer base address offset
#define RX_BUFFER_BASE (MEM_BASE_ADDR + 0x00300000) //rx buffer base address offset
#define SIZE_ARR 2048

int main()
{
	float inStreamData[SIZE_ARR];
	
	//printf ("Welcome:");
	//Pointers to DMA TX/RX addresses
	float *m_dma_buffer_TX = (float*) TX_BUFFER_BASE;
	float *m_dma_buffer_RX = (float*) RX_BUFFER_BASE;

	//printf("Initializing AxiDMA\n");
	axiDMA_cfg = XAxiDma_LookupConfig(XPAR_AXI_DMA_0_DEVICE_ID);
	if (axiDMA_cfg)
	{
		int status = XAxiDma_CfgInitialize(&axiDMA,axiDMA_cfg);
		if(status != XST_SUCCESS)
		{
			printf("Error Initializing AXI DMA core\n");
		}
	}
	//Disable Interrups
	XAxiDma_IntrDisable(&axiDMA, XAXIDMA_IRQ_ALL_MASK, XAXIDMA_DEVICE_TO_DMA);
	XAxiDma_IntrDisable(&axiDMA, XAXIDMA_IRQ_ALL_MASK, XAXIDMA_DMA_TO_DEVICE);


	float dataout[2048];

		//filling sample data in inStreamData
		for (int idx = 0; idx < 1024; idx++)
		{
			inStreamData[idx]=0.5*idx;
			inStreamData[idx+1024]=-0.5*idx;
		}
	
	//BEFORE PROCESS
	//Flush the cache of the buffers
	//Flush does write back the contents of cache to main memory
	
	//	------------------	<buffer_name>, <buffer_size>
	Xil_DCacheFlushRange((u32)inStreamData, SIZE_ARR*sizeof(u32));
	Xil_DCacheFlushRange((u32)m_dma_buffer_RX, SIZE_ARR*sizeof(u32));

	//printf("Sending Data to IP core slave\n");
	// ------------	--- <DMA instance> <buffer_name> <buffer_size> <transfer_direction>
	XAxiDma_SimpleTransfer(&axiDMA,(u32)inStreamData,SIZE_ARR*sizeof(u32),XAXIDMA_DMA_TO_DEVICE);

	//printf("Get The Data\n");
	XAxiDma_SimpleTransfer(&axiDMA,(u32)m_dma_buffer_RX,SIZE_ARR*sizeof(u32),XAXIDMA_DEVICE_TO_DMA);
	while(XAxiDma_Busy(&axiDMA,XAXIDMA_DEVICE_TO_DMA));


	//invalidate does mark cache lines as invalid so that future reads go to main memory.
	
	//AFTER PROCESS
	//Invalidate // future reading takes place from main memory (i.e, m_dma_buffer_RX), not corresponding cache.
	Xil_DCacheInvalidateRange((u32)m_dma_buffer_RX,SIZE_ARR*sizeof(u32));

	//Display Data
	for (int idx = 0; idx < SIZE_ARR; idx++)
		{
			dataout[idx]=m_dma_buffer_RX[idx];
		}
	return 0;
}
