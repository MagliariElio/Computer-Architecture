#line 1 "main.c"


extern int* Matrix_Coordinates;
extern char ROWS;
extern char COLUMNS;
extern int check_square(int x, int y, int z);
extern float my_division(float* a, float* b);


int main(void){
	int* matrix = Matrix_Coordinates;
	
	
	
	int rows = 5;	
	int cols = 5;	
	int r = 5;
	int tot = 0;
	
	int i = -1 * cols;
	while(i<cols) {
		int j = -1 * rows;
		while(j<rows) {
			int x = matrix[i+j*rows];
			int y = matrix[i+j*rows+1];
			tot += check_square(x, y, r);	
			j++;
		}
		i+=2;
	}
	
	r *= r;
	
	float a = ((float) tot);
	float b = ((float) r);
		
	tot = my_division(&a, &b);
	
	
	return 0;
}
