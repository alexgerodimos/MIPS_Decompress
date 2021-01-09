		.data

chars:		.ascii "ABCDEFGHIJKLMNOPQRSTUVWXYZ .,!-'"

msg1:    	.word 0x93EA9646, 0xCDE50442, 0x34D29306, 0xD1F33720

        	.word 0x56033D01, 0x394D963B, 0xDE7BEFA4  

msg1end:

		.text
main:
		la $s0, msg1end		# $s0 = address of end of message
		la $s1, msg1		# $s1 = address of next byte
		
loop:
		beq $s1, $s0, end	# repeat while address of next byte is not address of end
		blt $s2, 5, nextbyte	# if not enough bits to make a character, load next byte
		subi $s2, $s2, 5	# subtract 5 bits used to write character
		srlv $t2, $s3, $s2	# t2 = buffer shifted right by number of bits
		and $t2, 0x1F		# set unimportant bits to zero
		
		lb $a0, chars($t2)	# print corresponding character
		li $v0, 11
		syscall
		
		j loop
		
nextbyte:
		lbu $t1, ($s1)		# save next byte into t1
		addi $s1, $s1, 1	# incriment next byte
		sll $s3, $s3, 8		# shift buffer (s3) left 8 bits to make room
		or $s3, $s3, $t1	# append stored byte onto buffer
		addi $s2, $s2, 8	# add 8 bits
		
		j loop
end:
		li $v0, 10		# exit
		syscall