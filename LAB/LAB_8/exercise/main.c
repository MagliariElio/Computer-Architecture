

extern int Matrix_Coordinates[];
extern char ROWS;
extern char COLUMNS;
extern int check_square(int x, int y, int z);
extern float my_division(float* a, float* b);


int main(void){
	int *matrix = Matrix_Coordinates;	
	int rows = (int) ROWS;
	int cols = (int) COLUMNS;
	int r = 2;														//radius
	int tot = 0;
	
	int i = 0;						//index for rows
	while(i<rows) {
		int j = 0;					//index for columns
		while(j<cols) {
			int x = matrix[i*cols+j];
			int y = matrix[i*cols+j+1];
			tot += check_square(x, y, r);	
			j += 2;
		}
		i++;
	}
	
	r *= r;
	
	float a = ((float) tot);
	float b = ((float) r);
		
	float result = my_division(&a, &b);								//result of pi
	
	__asm__("SVC 0xCA");
	__asm__("SVC 0xFE");
	
	return 0;
}
