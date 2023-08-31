#include <stdio.h>
#define SIZE 10

// function prototypes: should not remove these
int add(int a, int b);
void changeVal();
void initArr2();

//int val = 0;
//int arr[] = {1,2,3,4,5,6};
//int arr2[SIZE];

// global vars are in another file. you can use extern for them.
extern int val;
extern int arr[];
extern int arr2[SIZE];

// add and changeVal will be in another file (either comment/remove/ or give different name to avoid conflict)
int _add(int a, int b) {
		return a +b;
}

void _changeVal() {
		val += 1;
}

void _initArr2() {
		register int i;
		for (i = 0; i < SIZE; i++) {
				arr2[i] = i*2;
		}

}


// main function will call some methods from another file
// labelnames of functions or variables MUST BE SAME. (so do not use globalVarName_m notation in this case: just globalVarName)

void printStuff() {
		printf("-----------------------");
		printf("val is %d\n", val);
		printf("arr is:   ");
		for (int i = 0; i < 6; i++) {
				//printf("arr[%d]: %d  ", i, arr[i]);
				printf("%d  ", arr[i]);
		}
		printf("\narr2 is:  ");
		for (int i = 0; i < SIZE; i++) {
				//printf("arr2[%d]: %d  ", i, arr2[i]);
				printf("%d  ", arr2[i]);
		}
		printf("\n");
}
int main() {

		printStuff();
		changeVal();
		for (int i = 0; i < 6; i++) {
				arr[i] = add(arr[i], 2);
		}
		initArr2();
		printStuff();


}
