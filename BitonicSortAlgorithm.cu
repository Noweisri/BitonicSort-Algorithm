%%cu
#include <stdio.h>
#include<stdlib.h>
#include<malloc.h>
#include <math.h>
#include <cuda_runtime.h>
#include "device_launch_parameters.h"


__global__ void bitonicSort(int* arr, int i, int j, int n)
{

    int index = blockDim.x * blockIdx.x + threadIdx.x;
    int seqLength = (int)pow(2, (i - j + 1));
    int skip = (int)pow(2, (i - j));
    int temp;
 

    if (index % seqLength < skip)
    { 
        if ( index < n - 1)
        {
            
            // Ascending step
            if ((index / ((int)pow(2, i)) % 2) == 0)
            { 
                if (arr[index] > arr[index + skip])
                { 

                    temp = arr[index];
                    arr[index] = arr[index + skip];
                    arr[index + skip] = temp;
                }
            }
            else
            { 
                // Descending step
                if (arr[index] < arr[index + skip])
                {
                    temp = arr[index];
                    arr[index] = arr[index + skip];
                    arr[index + skip] = temp;  
                }
            }
        }
    }
}


int main(void)
{
    int n = 16;
    int size = n * sizeof(int);
    int threads = 16;
    int blocks = (n + threads - 1) / threads;
    int* arr = (int*)malloc(size);
    int* sorted_arr = (int*)malloc(size);
    int* d_arr;
 

    // Assign array elements and print it
    printf("Orignal array of %d elements :\n{", n);
    for (int i = 0; i < n; i++)
    {
      arr[i] = rand() % n;
      if(i == n-1)
        printf(" %d }", arr[i]);
        else
          printf(" %d ,", arr[i]);
    }
    
    // Allocate memory
    cudaMalloc((void**)&d_arr, size);


    // Copy to device
    cudaMemcpy(d_arr, arr, size, cudaMemcpyHostToDevice);


    // Call kernel (Bitonic sort) with (log(n)) / log(2)) times
    for (int step = 1; step <= (log(n)) / log(2); step++)
    {
        for (int stage = 1; stage <= step; stage++)
        {
            bitonicSort<<< blocks , threads >>>(d_arr, step, stage, n);

            cudaMemcpy(sorted_arr, d_arr, size, cudaMemcpyDeviceToHost); 

            /*printf("\nstep (%d) and stage (%d) : \n", step, stage);
            for (int k = 0; k < n; k++) {
                printf("[%d] ", sorted_arr[k]);
            }
            printf("\n");
            free(sorted_arr);
            sorted_arr = (int*)malloc(size); 
         */
        }
    }

    // Copy results back to host
    cudaMemcpy(sorted_arr, d_arr, size, cudaMemcpyDeviceToHost);

    // Print results
    printf("\nArray after being sorted :\n{");
    for (int i = 0; i < n-1; i++)
    {
          printf(" %d ,", sorted_arr[i]);
     }
    printf(" %d }",sorted_arr[n-1]);

    // Free variables
    cudaFree(d_arr);
    free(arr);
    free(sorted_arr);

    return 0;
}