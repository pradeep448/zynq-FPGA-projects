#include "hls_math.h"
struct my{
  float data;
  bool last;
};

void InIP(my in[2048], my out1[1024], my out2[1024])
// re=0-1023, im=1024-2047
{

//  ----------------- <protocol_type> <port_name>

#pragma HLS INTERFACE ap_ctrl_none port=return //ap_ctrl_none: No block-level I/O protocol, 
#pragma HLS INTERFACE axis port=in
#pragma HLS INTERFACE axis port=out1
#pragma HLS INTERFACE axis port=out2
///////////////////////////////////////////////////

    float data[2048]; 
    bool last[2048];

    for(int k=0;k<2048;k++)
        {
#pragma HLS PIPELINE
            data[k] = in[k].data; //incoming data
            last[k] = in[k].last;
			//2048+1
        }

        for(int k=0;k<1024;k++)
        {
#pragma HLS PIPELINE
            out1[k].data = data[k]; 	//re
            out2[k].data = data[k+1024];//im
            out1[k].last = last[k+1024];//send last bit of im array, because no last in re array
            out2[k].last = last[k+1024];//send last bit of im array, because no last in re array
			//1024+3
        }
     }
