volatile char* const serial_out = (volatile char*)(0xFE00);
volatile unsigned short* const tb_data = (volatile unsigned short*)(0xFE02);

const char str[] = "Hellorld!\r\n";
const char hex_chars[] = "0123456789ABCDEF";
unsigned short arr[] = {0x877, 0, 33, 0x1938, 0xAB77, 1481, 18888, 193, 1999, 1, 48, 1, 69, 621, 69, 621, 481, 59184, 1, 888, 1984, 19, 45718, 59, 8, 19481, 9411, 2023, 2024, 0x0621, 948, 0x194, 0xAAAA, 0xAA01, 819, 0x19AB, 0xFFFF, 0x0000, 0x9184, 1849, 682, 0x0682, 1049};
unsigned short arr2[sizeof(arr)>>1];

void printHex(unsigned short a);
void newl();
void puts(const char *__s);
signed long fixed_abs_16(signed long ar) { return ar < 0 ? -ar : ar; }
signed long fixed_mul_16(signed long x, signed long y) { return ((signed long long)x * (signed long long)y) >> 16; }
signed long fixed_div_16(signed long x, signed long y) {
	#ifdef DEBUG_FIXEDPOINT
	newl();
	printHex(x >> 16);
	printHex(x & 0xFFFF);
	*serial_out = '/';
	printHex(y >> 16);
	printHex(y & 0xFFFF);
	*serial_out = '=';
	signed long long temp = (signed long long)x * (1LL << 16LL);
	printHex(temp >> 48);
	printHex((temp >> 32) & 0xFFFF);
	printHex((temp >> 16) & 0xFFFF);
	printHex(temp & 0xFFFF);
	*serial_out = '/';
	printHex(y >> 16);
	printHex(y & 0xFFFF);
	*serial_out = '=';
	asm volatile("seti");
	signed long res = temp / (signed long long)y;
	asm volatile("seti");
	printHex(res >> 16);
	printHex(res & 0xFFFF);
	return res;
	#else
	return ((signed long long)x * (1LL << 16LL)) / (signed long long)y;
	#endif
}
#ifdef BUGGED
int softdiv(int a, int b) {
	int res;
	asm("mov %1, r3;"
		"mov %2, r4;"
		"clr r2;"
		"div r4, r2;"
		"mov r3, %2;"
		: "=r" (res)
		: "r" (a), "0" (b)
		: "r2", "r3", "r4");
	return res;
}

void softmoddiv(int a, int b, int* res_o, int* mod_o) {
	char sign_a = a < 0;
	char sign_b = b < 0;
	char sign = sign_a ^ sign_b;
	if(a < 0) a = -a;
	if(b < 0) b = -b;
	unsigned int res = softdiv(a, b);
	
	if(res_o) *res_o = sign ? -res : res;
	if(mod_o) {
		*mod_o = a - res * b;
		if(sign_a) *mod_o = -*mod_o;
	}
}
#endif

const int tens[] = {10000, 1000, 100, 10, 1};
void printDecimal(int x) {
	int n;
	if(x < 0) {
		n = -x;
		*serial_out = '-';
	}else n = x;
	int r;
	char flag = 0;
	for(int i = 0; i < 5; i++) {
		#ifdef BUGGED
		r = softdiv(n, tens[i]);
		#else
		r = n / tens[i];
		#endif
		//softmoddiv(n, tens[i], &r, 0);
		//for(r=0;tens[i] <= n;r++,n-=tens[i]);
		if(flag || i == 4 || r != 0) {
			*serial_out = '0' + r;
			flag = 't';
		}
		n -= r * tens[i];
	}
}

void main(void) {
	unsigned short ptr = 0;
	while(str[ptr]) {
		*serial_out = str[ptr];
		ptr++;
	}
	printHex(0x8769);
	newl();
	printHex(621);
	newl();
	printHex(0);
	newl();
	printHex(0x2101);
	*serial_out = '*';
	printHex(*tb_data);
	*serial_out = '=';
	unsigned long int m_res = 0x2101UL * *tb_data;
	printHex(m_res >> 16);
	printHex(m_res & 0xFFFF);
	newl();
	{
		puts("Unsorted:\r\n");
		int arr_len = sizeof(arr)>>1;
		for(int i = 0; i < arr_len; i++) {
			printHex(arr[i]);
			*serial_out = ' ';	
		}
		newl();
		int i = 1;
		while(i < arr_len) {
			int x = arr[i];
			int j = i - 1;
			while(j >= 0 && arr[j] > x) {
				arr[j + 1] = arr[j];
				j--;	
			}
			arr[j + 1] = x;
			i++;
			*serial_out = '\r';
			printHex(i);
			*serial_out = '/';
			printHex(arr_len);
		}
		newl();
		puts("Sorted:\r\n");
		for(int i = 0; i < arr_len; i++) arr2[i] = arr[i];
		for(int i = 0; i < arr_len; i++) {
			printHex(arr2[i]);
			*serial_out = ' ';	
		}
		newl();
	}
	puts("sizeof(signed int) = ");
	printHex(sizeof(signed int));
	newl();
	puts("sizeof(signed long) = ");
	printHex(sizeof(signed long));
	newl();
	puts("sizeof(signed long long) = ");
	printHex(sizeof(signed long long));
	newl();
	{
		puts("Sieve of Eratosthenes\r\n");
		const int count = 256;
		unsigned char sieve[256];
		int i,j,k;
		for(i = 0; i < count; i++) sieve[i] = 0;
		puts("2,");
		for(i = 0; i < count; i++){
			if(sieve[i] == 0){
				j = i * 2 + 3;
				printDecimal(j);
				*serial_out = ',';
				k = i;
				while(1){
					if(k >= count) break;
					sieve[k] = 1;
					k += j;
				}
			}
		}
		puts("END");
		newl();
	}
	asm volatile("halt");
	while(1);
}

void puts(const char *__s) {
	while(*__s) {
		*serial_out = *__s;
		__s++;	
	}
}

void newl() {
	*serial_out = 0x0D;
	*serial_out = 0x0A;
}

void printHex(unsigned short a) {
	for(char i = 0; i < 4; i++) {
		*serial_out = hex_chars[(a & 0xF000) >> 12];
		a <<= 4;
	}
}
