#include <stdio.h>
#include <stdlib.h>

const int rows_ifmap = 5;
const int columns_ifmap = 5;
const int rows_kernel = 3;
const int columns_kernel = 3;

int calcola(int *ifmap, int index_ifmap, int *kernel);


int main() {
	int *ifmap = (int *) malloc(5 * 5 * sizeof(int));
	int *kernel = (int *) malloc(3 * 3 * sizeof(int));
	int *ofmap = (int *) malloc(3 * 3 * sizeof(int));
	
	/*for(int i=0; i<(rows_ifmap*columns_ifmap); i++) {
		ifmap[i] = 1;
	}
	
	for(int i=0; i<(rows_kernel*columns_kernel); i++) {
		kernel[i] = 1;
	}*/
	
	ifmap[0] = 0;
	ifmap[1] = 0;
	ifmap[2] = 0;
	ifmap[3] = 0;
	ifmap[4] = 0;
	ifmap[5] = 0;
	ifmap[6] = 1;
	ifmap[7] = 2;
	ifmap[8] = 3;
	ifmap[9] = 0;
	ifmap[10] = 0;
	ifmap[11] = 4;
	ifmap[12] = 5;
	ifmap[13] = 6;
	ifmap[14] = 0;
	ifmap[15] = 0;
	ifmap[16] = 7;
	ifmap[17] = 8;
	ifmap[18] = 9;
	ifmap[19] = 0;
	ifmap[20] = 0;
	ifmap[21] = 0;
	ifmap[22] = 0;
	ifmap[23] = 0;
	ifmap[24] = 0;
	ifmap[25] = 0;
	
	kernel[0] = 0;
	kernel[1] = -1;
	kernel[2] = -1;
	kernel[3] = 0;
	kernel[4] = 2;
	kernel[5] = 1;
	kernel[6] = 1;
	kernel[7] = 0;
	kernel[8] = 4;
	
	int i = 0;															// indice per spostarmi in ifmap
	
	// numero di sottomatrici di kernel in ifmap: numero di combinazioni del kernel (per righe * per colonne) in ifmap
	int numero_sottomatrici = (rows_ifmap - rows_kernel + 1) * (columns_ifmap - columns_kernel + 1);
	
	for(int j=0; j<numero_sottomatrici; j++) {
		int valore = calcola(ifmap, i, kernel);							// calcola una intera sottomatrice in ifmap
		i++;
		
		ofmap[j] = valore;
		
		if((j+1) % columns_kernel == 0) {
			i += rows_ifmap - rows_kernel;
		}
	}
	
	for(i=0; i<9; i++) {
		printf("%d\t", ofmap[i]);
		if((i+1) % rows_kernel == 0) {
			printf("\n");
		}
	}
	
	free(ifmap);
	free(ofmap);
	free(kernel);
}



int calcola(int *ifmap, int index_ifmap, int *kernel) {
	int j = 0;												// indice per spostarmi nella matrice kernel
	int count_column = 0;									// contatore colonne in ifmap
	int count_row = 0;										// contatore righe in ifmap
	int i = index_ifmap;									// indice per spostarmi in ifmap inizializzato al primo valore della sottomatrice
	int valore = 0;											// valore del calcolo della sottomatrice
	
	// eseguo ogni riga della sottomatrice in ifmap
	while(count_row < rows_kernel) {
		valore += ifmap[i] * kernel[j];
		
		count_column++;										// spostamento indice nella colonna
		
		if(count_column == columns_kernel) {
			count_column = 0;								// azzeramento numero colonne logiche della riga
			int offset = rows_ifmap - rows_kernel;			// offset di quante volte deve traslare nella colonna
			i += offset;									// spostamento indice nella giusta colonna della riga successiva
			count_row++;
		}
		
		j++;
		i++;
	}
	
	return valore;
}


