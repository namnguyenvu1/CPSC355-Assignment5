define(i_r, w23)				// Set i_r to register w23 (For readability)
define(j_r, w24)				// Set j_r to register w24 (For readability)
define(count_r, w25)				// Set count_r to register w25 (For readability)

QUEUESIZE = 8					// Define value for QUEUESIZE
MODMASK = 0x7					// Define value for MODMASK
FALSE = 0					// Define value for FALSE
TRUE = 1					// Define value for TRUE

	.data					// Start of data section
	.global queue				// Initialize global variable queue
	.global head				// Initialize global variable head
	.global tail				// Initialize global variable tail
queue:	.skip QUEUESIZE*4			// Set aside QUEUESIZE*4 bytes for global variable queue
head:	.word -1				// Initialize the value of global variable head to -1
tail:	.word -1				// Initialize the value of global variable tail to -1

        .text										// Start of text section
overflow:       .string "Queue overflow! Cannot enqueue into a full queue.\n"		// Create string for "queue overflow" to print later in the program
underflow:      .string "Queue underflow! Cannot enqueue into a full queue.\n"		// Create string for "queue underflow" to print later in the program
empty:          .string "\nEmpty queue\n"						// Create string to print when empty queue occur
content:        .string "\nCurrent queue contents:\n"					// String to print later in the program
cont:           .string "  %d"								// String to print later in the program
head_string:	.string " <-- head of queue"						// String indicate head of queue to print later in the program
tail_string:   	.string " <-- tail of queue"						// String indicate tail of queue to print later in the program
new_line:       .string "\n"								// String to print later in the program

        .balign 4				// Set alignment for function enqueue
        .global enqueue				// Make function enqueue available across all files					
enqueue:stp     x29, x30, [sp, -16]!		// 2 lines to start enqueue function
        mov     x29, sp

        mov     w26, w0                         // Mov int value to w26 (To preserve the value of int value, later w0 will be overwritten)
        bl      queueFull			// Call queueFull() (value will be stored in w0)

        cmp     w0, TRUE			// Compare queueFull() and TRUE
        b.ne    enqueueFalse1			// If queueFull() not True, branch over

        ldr     x0, =overflow			// 2 lines to print "queue overflow" error if queueFull() == TRUE
        bl      printf
	b	enqueueReturn			// return; (If queue has already full)
enqueueFalse1:
	bl      queueEmpty			// Call queueEmpty() (value will be stored in w0)
        cmp     w0, TRUE			// Compare queueEmpty() and TRUE
        b.ne    enqueueFalse2			// if queueEmpty() not True, branch over

	ldr	x9, =head			// Load the value of global variable head to x9
        ldr     w20, [x9]			// Load the value of x9 (head) to w20
        mov     w20, 0				// Set w20 (head) to 0
        str     w20, [x9]			// Store w20 (head) back to x9

	ldr	x10, =tail			// Load the value of global variable tail to x10
        ldr     w19, [x10]			// Load the value of x10 (tail) to w19
        mov     w19, 0				// Set w19 (tail) to 0
        str     w19, [x10]			// Store w19 (tail) back to x10
	b	enqueueTrue2			// Branch over else (enqueueFalse2) 
enqueueFalse2:  
	ldr	x10, =tail			// Load the value of global variable tail to x10
	ldr     w19, [x10]			// Load the value of x10 (tail) to w19
        add     w19, w19, 1			// ++tail
        and     w19, w19, MODMASK		// tail = ++tail & MODMASK
        str     w19, [x10]			// Store w19 (tail) back to x10
enqueueTrue2:
	ldr	w19, [x10]			// Load the value of x10 (tail) to w19
	ldr	x28, =queue			// Load the queue to x28
	str	w26, [x28, w19, SXTW 2]		// Store w26 (int value) to the queue
enqueueReturn:
        ldp     x29, x30, [sp], 16		// 2 lines to end the function
        ret


	.balign 4				// Set alignment for function dequeue
	.global dequeue				// Make function dequeue available across all files
	value_size = 4				// Size of int
	alloc = -(16 + value_size) & -16	// Calculate the allocation size
	dealloc	= -alloc			// Calculate the deallocation size
dequeue:stp	x29, x30, [sp, alloc]!		// 2 lines to start dequeue function
	mov	x29, sp

	bl	queueEmpty			// Call queueEmpty() (value will be stored in w0)
	cmp	w0, TRUE			// Compare queueEmpty() and TRUE
	b.ne	dequeueFalse1			// if queueEmpty() not True, branch over
	
	ldr	x0, =underflow			// 2 lines to print "queue underflow" error if queueFull() == TRUE
	bl	printf
	mov	w0, -1				// return (-1);
dequeueFalse1:
	ldr	x9, =head			// Load the value of global variable head to x9
	ldr	w20, [x9]			// Load the value of x9 (head) to w20
	ldr	x10, =queue			// Load the queue to x10
	ldr	w21, [x10, w20, SXTW 2]		// Load the value from queue[head] to w21 (value)

	ldr	x10, =tail			// Load the value of global variable tail to x10
	ldr	w19, [x10]			// Load the value of x10 (tail) to w19
	cmp	w20, w19			// Compare head and tail
	b.ne	dequeueFalse2			// If head not equal tail, branch to else
	
	mov	w20, -1				// Mov -1 to w20
	str	w20, [x9]			// Store w20 to x9 (head) (head = -1)
	mov	w19, -1				// Mov -1 to w19
	str	w19, [x10]			// Store w19 to x10 (tail) (tail = -1)
	b	dequeueTrue2			// Branch over else (avoid assign value to head again)
dequeueFalse2:
	add	w20, w20, 1			// ++head
	and	w20, w20, MODMASK		// head = ++head & MODMASK
	str	w20, [x9]			// Store w20 (head) to x9(head)
dequeueTrue2:
	mov	w0, w21				// Mov w21 (value) to w0 (return value)
	
	ldp	x29, x30, [sp], dealloc		// 2 lines to end the function
	ret


	.balign 4				// Set alignment for function queueFull
	.global queueFull			// Make function queueFull visible across all files
queueFull:
	stp     x29, x30, [sp, -16]!		// 2 lines to start queueFull function
        mov     x29, sp

	ldr	x9, =tail			// Load the value of global variable tail to x9
	ldr	w19, [x9]			// Load the value of x9 (tail) to w19
	add	w19, w19, 1			// w19 = (tail + 1)
	and	w19, w19, MODMASK		// w19 = (tail + 1) & MODMASK
	ldr	x9, =head			// Load the value of global variable head to x9
	ldr	w20, [x9]			// Load the value of x9 (head) to w20
	cmp	w19, w20			// Compare (tail + 1) & MODMASK and head
	b.ne	queueFullElse			// If not equal, branch to else

	mov	w0, TRUE			// return TRUE;
	b	queueFullSkip			// Branch to the end of the function (Avoid reassign return value)
queueFullElse:
	mov	w0, FALSE			// return FALSE;
queueFullSkip:
	ldp     x29, x30, [sp], 16		// 2 lines to end function
        ret


	.balign 4				// Set alignment for function queueEmpty
	.global queueEmpty			// Make function queueEmpty visible across all files
queueEmpty:
	stp     x29, x30, [sp, -16]!		// 2 lines to start queueEmpty function
        mov     x29, sp

	ldr	x9, =head			// Load the value of global variable head to x9
	ldr	w20, [x9]			// Load the value of x9 (head) to w20
	cmp	w20, -1				// Compare head with -1
	b.ne	queueEmptyElse			// If not equal, branch to else

	mov	w0, TRUE			// return TRUE;
	b	queueEmptySkip			// Branch to the end of the function (Avoid reassign return value)
queueEmptyElse:
	mov	w0, FALSE			// return FALSE;
queueEmptySkip:
	ldp     x29, x30, [sp], 16		// 2 lines to end function
        ret


	.balign 4				// Set alignment for function display
	.global display				// Make function display visible across all files
	i_size = 4				// Size of int i
	j_size = 4				// Size of int j
	count_size = 4				// Size of int count
	alloc = -(16 + i_size + j_size + count_size) & -16	// Calculate the allocation size
	dealloc = -alloc					// Calculate the deallocation size
display:stp	x29, x30, [sp, alloc]!		// 2 lines to start display function
	mov	x29, sp

	bl	queueEmpty			// Call function queueEmpty() (value will be store in w0)
	cmp	w0, TRUE			// Compare queueEmpty() and TRUE
	b.ne	displayFalse1			// If queueEmpty() not equal TRUE, branch to else

	ldr	x0, =empty			// Load "empty" string to print
	bl	printf				// Print string "empty"
	b	displayReturn			// return;
displayFalse1:
	ldr	x9, =head			// Load the value of global variable head to x9
	ldr	w19, [x9]			// Load the value of x9 (head) to w19
	ldr	x10, =tail			// Load the value of global variable tail to x10
	ldr	w20, [x10]			// Load the value of x10 (tail) to w20
	sub	count_r, w20, w19		// count = head - tail
	add	count_r, count_r, 1		// count = head - tail + 1
	
	cmp	count_r, 0			// Compare count and 0
	b.gt	displayFalse2			// If count > 0, branch over
	add	count_r, count_r, QUEUESIZE	// count += QUEUESIZE
displayFalse2:
	ldr	w0, =content			// Load the string "Current queue content" for printing 
	bl	printf				// Print the string "Current queue content"
	mov	i_r, w19			// i = head

	mov	j_r, 0				// Set j = 0 to begin the loop
	b	displayTest			// Branch to test (pre-loop test)

displayLoop:
	ldr	x0, =cont			// Load the printing string
	ldr	x11, =queue			// Load the queue to x11
	ldr	w1, [x11, i_r, SXTW 2]		// Set up the first printing statement
	bl	printf				// Print the string

	cmp	i_r, w19			// Compare i and head
	b.ne	displayFalse3			// If i not equal head, branch over if condition
	ldr	x0, =head_string		// Load string "head_string" to x0
	bl	printf				// Call printf
displayFalse3:
	cmp	i_r, w20			// Compare i and tail
	b.ne	displayFalse4			// If i not equal tail, branch over if condition
	ldr	x0, =tail_string		// Load string "tail_string" to x0
	bl	printf				// Call printf
displayFalse4:	
	ldr	x0, =new_line			// Load string "\n" to x0
	bl	printf				// Call printf
	add	i_r, i_r, 1			// i_r = ++i
	and	i_r, i_r, MODMASK		// i_r = ++i & MODMASK

	add	j_r, j_r, 1			// Update j
displayTest:
	cmp	j_r, count_r			// Compare j and count
	b.lt	displayLoop			// If j >= count, exit the loop
displayReturn:
	ldp	x29, x30, [sp], dealloc		// 2 lines to end the function
	ret
