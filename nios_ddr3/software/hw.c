#include "stdio.h"

typedef unsigned char uchar;
typedef unsigned  int uint;

volatile uchar *pLED = (uchar*)0x40;
volatile uchar *pSW  = (uchar*)0x30;
volatile uchar *pDIP = (uchar*)0x20;
volatile uint  *pTMR = (uint *)0x00;

// DRAM
volatile uint *pS = (uint*)0x8000000;
volatile uint *pE = (uint*)0xfffffff;


// Copy switch patterns to LEDs
void sw_copy()
{
	uint dip = *pDIP;
	uint sw = *pSW;
	*pLED = (sw<<6) | (dip<<3) | dip;
}


// Force cached/uncached
//    only 0 (cached) or 1 (bypassed/uncached)
#define UNCACHED 0
#define BIT31 (UNCACHED<<31)

// LFSR pattern taken from Wikipedia
// warning: do not seed with all zeros
inline uint lfsr32( uint lfsr )
{
	// taps: 32 31 29 1; feedback polynomial: x^32 + x^31 + x^29 + x + 1
    lfsr = (lfsr >> 1) ^ (-(lfsr & 1u) & 0xD0000001u);
	return lfsr;
}

#define MAJOR (1<<22)
#define MAX_CNT_MASK (MAJOR-1)
inline int count( uint *pcnt, uint lfsr )
{
	int p = *pcnt;
	p = (p+1) & MAX_CNT_MASK;
	*pcnt = p;
	if( !(p&(MAX_CNT_MASK>>4)) ) *pLED=~lfsr;
	if( !p ) { printf("%08x ",lfsr); return 1;}
	return 0;
}

void print_rwerr( char *pfx, int reads, int writes, int errs )
{
	printf("%s, reads:%d writes:%d errors:%d\n", pfx, reads, writes, errs );
}

void mem_test( int num_write_passes, int num_read_passes )
{
	volatile uint *p;
	uint num_writes = 0;
	uint num_reads  = 0;
	uint num_errors = 0;
	uint bitpat_wr  = 0;
	uint bitpat_wr_init = 0;
	uint reads=0,writes=0,errors=0;

	while( num_write_passes-- ) {
		printf("writing\n");
		bitpat_wr_init = lfsr32(~num_write_passes);  // avoid all-zeros to seed LFSR
		writes = 0;
		bitpat_wr = bitpat_wr_init;
		for( p=pS; p<=pE; p++ ) {
			*p = bitpat_wr = lfsr32(bitpat_wr);
			num_writes += count( &writes, bitpat_wr );
		}
		writes += (num_writes*MAJOR);
		print_rwerr( "\nwrite pass done", reads, writes, errors );

		int read_passes = num_read_passes;
		while( read_passes-- ) {
			printf("reading\n");
			errors = 0;
			reads = 0;
			bitpat_wr = bitpat_wr_init;
			for( p=pS; p<=pE; p++ ) {
				bitpat_wr = lfsr32(bitpat_wr);
				if( *p != bitpat_wr ) {
					num_errors += count( &errors, bitpat_wr );
				}
				num_reads += count( &reads, bitpat_wr );
			}
			reads += (num_reads*MAJOR);
			errors += (num_errors*MAJOR);
			print_rwerr( "\nread pass done", reads, writes, errors );
		}
		print_rwerr( "read-write pass done", reads, writes, errors );

	}
	print_rwerr( "mem test done", reads, writes, errors );
}

int main()
{
	printf("\n\nhello world\n");

	mem_test( 256, 2 );
	while(1) sw_copy();
	return 0;
}
