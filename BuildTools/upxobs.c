#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define rep_UPX0 "PKT1"
#define rep_UPX1 "PKT0"

int main(int argc, char *argv[]) {
	FILE *inpExe, *outExe;
	char fname[0xff], ftemp[0xff], fbak[0xff];
	char buffer[0xff];
	int bufLen, pos, fcs, recount;
	if (argc > 0) {
		strcpy(fname, argv[1]);
		inpExe = fopen(fname, "rb");
		if (inpExe == NULL) {
			printf("Gagal membuka file %s!\n", fname);
			return EXIT_FAILURE;
		}
		strcpy(ftemp, fname);
		strcat(ftemp, ".tmp");
		outExe = fopen(ftemp, "wb");
		if (outExe == NULL) {
			printf("Gagal membuat file %s!\n", ftemp);
			return EXIT_FAILURE;
		}
		
		rewind(inpExe);
		fcs = 0;
		recount = 0;
		while (!feof(inpExe)) {
			bufLen = fread(buffer, 1, 0xff, inpExe);
			for (pos=0; pos<bufLen-3; pos++) {
				if ((buffer[pos] == 0x55) && (buffer[pos+1] == 0x50) && (buffer[pos+2] == 0x58)) {
					if (buffer[pos+3] == 0x30) {
						memcpy(&buffer[pos], rep_UPX0, 4);
						printf("Mengganti UPX0 di posisi 0x%.8x\n", fcs+pos);
						recount++;
					} else 
					if (buffer[pos+3] == 0x31) {
						memcpy(&buffer[pos], rep_UPX1, 4);
						printf("Mengganti UPX1 di posisi 0x%.8x\n", fcs+pos);
						recount++;
					}
				}
			}
			fcs+= bufLen;
			bufLen = fwrite(buffer, 1, bufLen, outExe);
		}
		fclose(outExe);
		fclose(inpExe);
		
		if (recount > 0) {
			printf("%d string berhasil diganti!\n", recount);
			strcpy(fbak, fname);
			strcat(fbak, ".bak");
			remove(fbak);
			printf("Membuat file backup \"%s\"...\n", fbak);
			rename(fname, fbak);
			printf("Mengganti file asli \"%s\"...\n", fname);
			rename(ftemp, fname);
		} else {
			printf("Hmm, tidak ada string yang diganti!\n");
			remove(ftemp);
		}
		
		printf("Selesai!\n");
		
	}
	return EXIT_SUCCESS;
}