#include "hls_math.h"

struct my{
  float data;
  bool last;
};

void OutIP(my in1[1024], my in2[1024], my out1[2048])
{
	
//  ----------------- <protocol_type> <port_name>

#pragma HLS INTERFACE axis port=out1
#pragma HLS INTERFACE axis port=in2
#pragma HLS INTERFACE axis port=in1
#pragma HLS INTERFACE ap_ctrl_none port=return //ap_ctrl_none: No block-level I/O protocol, 
///////////////////////////////////////////////////

    float data[2048];
    bool last[2048];

    for(int k=0;k<1024;k++)
        {
#pragma HLS PIPELINE
            data[k] = in1[k].data; 		//re
            data[k+1024] = in2[k].data; //im
			last[k]=0; // last as array of zeros
			last[k+1024]=0;	
			//1024+3
        }

    last[2047]=1;

        for(int k=0;k<2048;k++)
        {
#pragma HLS PIPELINE
            out1[k].data = data[k];
            out1[k].last = last[k];
			//2048+1
        }
     }
