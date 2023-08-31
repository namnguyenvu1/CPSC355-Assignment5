define(i_r, w19)					// Define registers for easier readability
define(argc_r, w20)					// Define registers for easier readability
define(argv_r, x21)					// Define registers for easier readability

winter = 0						// Assign name for easier readability
spring = 1						// Assign name for easier readability
summer = 2						// Assign name for easier readability
fall = 3						// Assign name for easier readability

	.text
fmt:	.string "%s %s%s is %s\n"			// String for the output
error_s:.string	"usage: a5b mm dd\n"			// String for the number of argument error
monthErr_s:.string "Please check month input!\n"	// String for month input error
dayErr_s:.string "Please check day input!\n"		// String for day input error 
// String for day's prefix
th:	.string "th"					
st:	.string "st"
nd:	.string "nd"
rd:	.string "rd"
// Store string literals in .text
str_jan:.string "January"
str_feb:.string "February"
str_mar:.string "March"
str_apr:.string "April"
str_may:.string "May"
str_jun:.string "June"
str_jul:.string "July"
str_aug:.string "August"
str_sep:.string "September"
str_oct:.string "October"
str_nov:.string "November"
str_dec:.string "December"

str_win:.string "Winter"
str_spr:.string "Spring"
str_sum:.string "Summer"
str_fal:.string "Fall"

// Store global variables (pointer array) in .data section.
	.data
	.balign 8
month:	.dword  str_jan, str_feb, str_mar, str_apr, str_may, str_jun, str_jul, str_aug, str_sep, str_oct, str_nov, str_dec
season:	.dword	str_win, str_spr, str_sum, str_fal

// Store Code in .text section
	.text
	.balign 4					// Set alignment for main function
	.global main
main:	stp	x29, x30, [sp, -16]!			// 2 lines to start the main function
	mov	x29, sp
	
	mov   	argc_r, w0				// Copy argc to argc_r
	mov	argv_r, x1				// Copy argv to argv_r

	cmp	w0, 3					// Check if the number of argument is correct
	b.ne	error					// If not, branch to print the error message and end the function

	mov     w22, 1					// Mov 1 to w22
        ldr     x0, [argv_r, w22, SXTW 3]		// Load the first argument (month) to x0
        bl      atoi					// Call atoi, result will be stored in w0
	mov     w24, w0					// Store the month input to w24
	sub	w24, w24, 1				// month = month - 1 (calculate the index)

	mov     w22, 2					// Mov 1 to w22
        ldr     x0, [argv_r, w22, SXTW 3]		// Load the second argument (day) to x0
        bl      atoi					// Call atoi, result will be stored in w0
        mov     w25, w0					// Store the month input to w25
        sub     w25, w25, 1				// day = day - 1 (calculate the index) 

	cmp	w25, 0					// Compare w25 (day - 1) with 0
	b.lt	day_err					// If (day - 1) < 0, branch to print the error message and end the function

	cmp	w25, 0					// Compare (day - 1) with 0
	b.ne	next1					// If not equal, branch to check if day = 21
	ldr	x18, =st				// Otherwise, day suffix is "st"
	b	test_jan				// Branch over to avoid assign other suffix

next1:
	cmp     w25, 20					// Compare (day - 1) with 20
	b.ne	next2					// If not equal, branch to check if day = 31
        ldr     x18, =st				// Otherwise, day suffix is "st"
        b       test_jan				// Branch over to avoid assign other suffix

next2:
	cmp     w25, 30					// Compare (day - 1) with 30
	b.ne    next3					// If not equal, branch to check if day = 2
        ldr     x18, =st				// Otherwise, day suffix is "st"
        b       test_jan				// Branch over to avoid assign other suffix

next3:
	cmp	w25, 1					// Compare (day - 1) with 1
	b.ne    next4					// If not equal, branch to check if day = 22
	ldr	x18, =nd				// Otherwise, day suffix is "nd"
	b	test_jan				// Branch over to avoid assign other suffix

next4:
	cmp     w25, 21					// Compare (day - 1) with 21
	b.ne    next5					// If not equal, branch to check if day = 3
        ldr     x18, =nd				// Otherwise, day suffix is "nd"
        b       test_jan				// Branch over to avoid assign other suffix

next5:
	cmp	w25, 2					// Compare (day - 1) with 2
	b.ne    next6					// If not equal, branch to check if day = 23
	ldr	x18, =rd				// Otherwise, day suffix is "rd"
	b	test_jan				// Branch over to avoid assign other suffix

next6:
	cmp     w25, 22					// Compare (day - 1) with 22
	b.ne    next7					// If not equal, branch to assign "th" to day suffix
        ldr     x18, =rd				// Otherwise, day suffix is "rd"
        b       test_jan				// Branch over to avoid assign other suffix

next7:	ldr	x18, =th				// Assign "th" to day's suffix

// January
test_jan:
	cmp	w24, 0					// Compare (month - 1) with 0 (index for January)
	b.ne	test_feb				// If not, branch to check if month is February

	cmp     w25, 31                                 // Compare (day - 1) with 31
        b.ge    day_err                                 // If (day - 1) >= 31, branch to print the error message and end the function

jan:	mov	w26, winter				// Otherwise, every day on January is Winter
	b	print					// Branch to print the statement

// February
test_feb:
	cmp     w24, 1					// Compare (month - 1) with 1 (index for February)
        b.ne    test_mar				// If not, branch to check if month is March

	cmp     w25, 29                                 // Compare (day - 1) with 29
        b.ge    day_err                                 // If (day - 1) >= 29, branch to print the error message and end the function

feb:    mov     w26, winter				// Otherwise, every day on February is Winter
	b       print					// Branch to print the statement

// March
test_mar:
	cmp     w24, 2					// Compare (month - 1) with 2 (index for March)
        b.ne    test_apr				// If not, branch to check if month is April

	cmp     w25, 31                                 // Compare (day - 1) with 31
        b.ge    day_err                                 // If (day - 1) >= 31, branch to print the error message and end the function

        cmp     w25, 20					// Compare (day - 1) with 20
        b.ge    mar_spr					// If day >= 21, it is Spring
mar_win:mov     w26, winter				// Otherwise, it is still Winter
        b       print					// Branch to print the statement
mar_spr:mov     w26, spring				// If day > 22, it is Spring
	b       print					// Branch to print the statement

// April
test_apr:
        cmp     w24, 3					// Compare (month - 1) with 3 (index for April)
        b.ne    test_may				// If month not equal 4, branch to check if month is May

	cmp     w25, 30                                 // Compare (day - 1) with 30
        b.ge    day_err                                 // If (day - 1) >= 30, branch to print the error message and end the function

apr:    mov     w26, spring				// Otherwise, every day on April is Spring
	b       print					// Branch to print the statement

// May
test_may:
        cmp     w24, 4					// Compare (month - 1) with 4 (index for May)
        b.ne    test_jun				// If month not equal 5, branch to check if month is June

	cmp     w25, 31                                 // Compare (day - 1) with 31
        b.ge    day_err                                 // If (day - 1) >= 31, branch to print the error message and end the function

may:    mov     w26, spring				// Otherwise, every day on May is Spring
	b       print					// Branch to print the statement

// June
test_jun:
        cmp     w24, 5					// Compare (month - 1) with 5 (index for June)
        b.ne    test_jul				// If month not equal 6, branch to check if month is July

	cmp     w25, 30                                 // Compare (day - 1) with 30
        b.ge    day_err                                 // If (day - 1) >= 30, branch to print the error message and end the function

        cmp     w25, 20					// Compare (day - 1) with 20
        b.ge    jun_sum					// If day >= 21, it is Summer
jun_spr:mov     w26, spring				// Otherwise, it is still Spring
        b       print					// Branch to print the statement
jun_sum:mov     w26, summer				// If day > 22, it is Summer
	b       print					// Branch to print the statement

// July
test_jul:
        cmp     w24, 6					// Compare (month - 1) with 6 (index for June)
        b.ne    test_aug				// If month not equal 7, branch to check if month is August

	cmp     w25, 31                                 // Compare (day - 1) with 31
        b.ge    day_err                                 // If (day - 1) >= 31, branch to print the error message and end the function

jul:	mov     w26, summer				// Otherwise, every day on July is Summer
	b       print					// Branch to print the statement

// August
test_aug:
        cmp     w24, 7					// Compare (month - 1) with 7 (index for August)
        b.ne    test_sep				// If month not equal 8, branch to check if month is September

	cmp     w25, 31                                 // Compare (day - 1) with 31
        b.ge    day_err                                 // If (day - 1) >= 31, branch to print the error message and end the function

aug:    mov     w26, summer				// Otherwise, every day on August is Summer
	b       print					// Branch to print the statement

// September
test_sep:
        cmp     w24, 8					// Compare (month - 1) with 8 (index for September)
        b.ne    test_oct				// If month not equal 9, branch to check if month is October

	cmp     w25, 30                                 // Compare (day - 1) with 30
        b.ge    day_err                                 // If (day - 1) >= 30, branch to print the error message and end the function

        cmp     w25, 20					// Compare (day - 1) with 20
        b.ge    sep_fal					// If day >= 21, it is Fall
sep_sum:mov     w26, summer				// Otherwise, it is still Summer
        b       print					// Branch to print the statement
sep_fal:mov     w26, fall				// If day > 22, it is Fall
	b       print					// Branch to print the statement

// October
test_oct:
        cmp     w24, 9					// Compare (month - 1) with 9 (index for October)
        b.ne    test_nov				// If month not equal 10, branch to check if month is November

	cmp     w25, 31                                 // Compare (day - 1) with 31
        b.ge    day_err                                 // If (day - 1) >= 31, branch to print the error message and end the function

oct:    mov     w26, fall				// Otherwise, every day on October is Fall
	b       print					// Branch to print the statement

// November
test_nov:
        cmp     w24, 10					// Compare (month - 1) with 10 (index for November)
        b.ne    test_dec				// If month not equal 11, branch to check if month is December

	cmp     w25, 30                                 // Compare (day - 1) with 30
        b.ge    day_err                                 // If (day - 1) >= 30, branch to print the error message and end the function

nov:    mov     w26, fall				// Otherwise, every day on November is Fall
	b       print					// Branch to print the statement

// December
test_dec:
        cmp     w24, 11					// Compare (month - 1) with 11 (index for December)
        b.ne    month_err				// If month not equal 12, branch to month_err (We checked all month from 1 to 12)

	cmp     w25, 31                                 // Compare (day - 1) with 31
        b.ge    day_err                                 // If (day - 1) >= 31, branch to print the error message and end the function

	cmp	w25, 20					// Compare (day - 1) with 20
	b.ge	dec_win					// If day >= 21, it is Winter
dec_fal:mov     w26, fall				// Otherwise, it is still Fall
	b	print					// Branch to print the statement
dec_win:mov	w26, winter				// If day > 22, it is Winter
	b       print					// Branch to print the statement

print:	ldr	x0, =fmt				// Load the string to print to x0
	ldr	x23, =month				// Load the month's array to x23
	ldr	x1, [x23, w24, SXTW 3]			// Load the month to x1
	mov	w22, 2					// Mov 2 to w22 (2nd argument, the day)
	ldr	x2, [argv_r, w22, SXTW 3]		// Load the day to x2

	mov	x3, x18

	ldr	x27, =season				// Load the season array to x27
	ldr	x4, [x27, w26, SXTW 3]			// Load the season to be printed to x3
	bl	printf					// Print the statement
	b	end					// Branch to end (Avoid printing wrong error statement)

error:	ldr	x0, =error_s				// Load error string to x0
	bl	printf					// Print the error statement
	b 	end					// Branch to end (Avoid printing wrong error statement)
month_err:
	ldr	x0, =monthErr_s				// Load error string to x0
	bl	printf					// Print the error statement
	b 	end					// Branch to end (Avoid printing wrong error statement)

day_err:ldr	x0, =dayErr_s				// Load error string to x0
	bl	printf					// Print the error statement
	b	end					// Branch to end (Avoid printing wrong error statement)

end:	ldp	x29, x30, [sp], 16			// 2 lines to end program
	ret
