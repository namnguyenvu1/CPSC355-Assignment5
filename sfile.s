// main function will call some methods from another file
// labelnames of functions or variables MUST BE SAME. (so do not use globalVarName_m notation in this case: just globalVarName)
	SIZE = 10

	.data // GLOBAL VARS that are non-constant(read and WRITE) must not be in .text
	 // make these visible to other files
	.global val
	.global arr
	.global arr2

val: .word 0
arr: .word 1, 2, 3, 4, 5, 6
arr2: .skip SIZE*4 // .skip #bytesToAllocate,  we allocate memory for 10 elements and each int element is 4 bytes




	.text // INSTRUCTIONS MUST BE IN .text: READ-ONLY
	.balign 4


	// make these subroutines visible to other files
	.global add
	.global changeVal
	.global initArr2

	fp .req x29
	lr .req x30

add:
	stp fp, lr, [sp, -16]!
	mov fp, sp

	add w0, w0, w1

	ldp fp, lr, [sp], 16
	ret

changeVal:
	stp fp, lr, [sp, -16]!
	mov fp, sp

	// val+=1
	ldr x9, =val		// get address of global var: x9 = &val  (pick an x# register: not w#: addresses are 64bits)
	ldr w10, [x9]		// set w10 = *(&val)
	add w10, w10, 1
	str w10, [x9]		// save on ram location where val is stored: *(&val) = w10

	// changeVal is void type (no need to return anything)
	// but suppose changeVal wants to do 'return val': here how you would do it
	// step1: get the ADDRESS of global var, step2: just read/write with ldr/str
	// ldr x9, =val
	// ldr w0, [x9] // return value is in w0

	ldp fp, lr, [sp], 16
	ret

	// suppose we use w19
	// RULE TO FOLLOW: YOU MUST SAVE AND RESTORE CALLE SAVEE FROM STACK
	// OTHERWISE main method (that expects calle savee to be unchanged, if it uses them) might crash or print unexpected output	
	alloc = -(16 + 8) & -16
	dealloc = -alloc
initArr2:
	stp fp, lr, [sp, alloc]!
	mov fp, sp
	str x19, [fp, 16] // save calle saved on STACK: use whole 64 bits!!!! not just 32. even if you just use w19 high order bits can change!
	
	// by this point you are free to change register #19

	// register int i = 0
	mov w19, 0
	b pretest

looptop:
	// set arr2[i] = 2*i
	mov w9, 2
	mul w10, w19, w9 // you can rather also do add w10, w19, w19. But it is suggested to just follow C code EXACTLY.

	// get base address = arr2 = &arr2[0]
	ldr x9, =arr2 // x9 = base address
	// set arr2[i] = 2*i: just do it the same style you learned a few weeks ago about arrays
	str w10, [x9, w19, SXTW 2] // 'x9, w19, SXTW 2' evaluates to 'x9+(sign extend w19)<<2'
    //                                                           'x9+i*4'
    //                                                           'base address + i*size_of(int)'
	//                                                           '&arr[i]	

	// i++
	add w19, w19, 1
	
pretest:
	cmp w19, SIZE
	b.lt looptop


 
	ldr x19, [fp, 16] // restore calle saved
	ldp fp, lr, [sp], dealloc
	ret
