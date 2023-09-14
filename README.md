# BitonicSort-Algorithm in parallel
PLEASE NOTE THAT THIS FILE MAY NOT WORK PROPERLY WITHOUT USING THE NVIDIA CUDA TOOLKIT.

Bitonic sort is a sorting algorithm that can be efficiently implemented on GPUs using the CUDA toolkit. The basic idea of bitonic sort is to repeatedly divide the input array into two halves,
(Ascending half, descending half) and then sort the two halves in a way that preserves the relative ordering of elements with the same bit pattern. This process is repeated until the entire array is sorted.

the loop is in the host (main) and it will call the kernel (algorithm) in (log(n)) / log(2)) times.
