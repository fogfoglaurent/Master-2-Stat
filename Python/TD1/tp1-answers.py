# -*- coding: utf-8 -*-
import math
import random as rand

def exercice1():
	"""############################ Exercice 1 ############################################
	#program which concatenates 2 strings and prints the resulting unified string with
	#the e at the end of it. The 2 inputstrings are asked by the program"""

	print "[Exercice 1]"

	str1=str(raw_input('Please enter the first string value:'))
	str2=str(raw_input('Please enter the second string value:'))
	print str1+str2



def exercice2():
	"""############################ Exercice 2 ############################################
	#  asks for a number to the user"""

	print "[Exercice 2]"

	value=int(raw_input('Please enter a number:'))

	# output wether X is odd or even
	if value%2 == 0:
	    print( 'Even number')
	else:
	    print( 'Odd number' )


def exercice3():
	"""############################ Exercice 3 ############################################"""

	print "[Exercice 3]"

	# 1. creates an array and initialize it with the strings ”FR”, ”UK”, ”DE” and ”NL”
	l=['FR','UK','DE','NL']

	# 2. Prints the size of this array
	print len(l)

	# 3. prints the content of this arrays using comma as the element separator
	# The join function is very useful to properly print list as a well-formatted string.
	print ','.join(l)


def exercice4():
	"""############################ Exercice 4 ############################################"""

	print "[Exercice 4]"

	# 1. Asks for the user to enter 3 numbers and stores them in a array
	n1=int(raw_input('Input the first number :'))
	n2=int(raw_input('Input the second number :'))
	n3=int(raw_input('Input the third number :'))
	l=[n1,n2,n3]

	# 2. prints the content of the array using the character ’+’ as the element separator
	print '+'.join(map(str,l))

	# 3. Computes and displays the sum
	print sum(l)

	# 4. Outputs the number of non-null elements.
	print len(l)-l.count(0)



def exercice5():
	"""############################ Exercice 5 ############################################"""

	print "[Exercice 5]"

	# 1. Asks for the user to enter 2 numbers

	def calculate():
		n1=int(raw_input('Input the first number :'))
		n2=int(raw_input('Input the second number :'))

		# 2. ask for the operator (a member of the ensemble {+ , − , ∗ , /, %})
		ope=raw_input('Input the operator:')

		# 3. outputs the results accordingly
		if ope == '+':
		    print n1+n2
		elif ope == '-':
		    print n1-n2
		elif ope == '*':
		    print n1*n2
		elif ope == '/':
		    print n1/n2
		elif ope == '%':
		    print n1%n2

	calculate()

	# asks for a new operation (possible answers are yes and no
	answer = raw_input('Do you want to perform other calculation ? (yes/no):')
	while answer == 'yes':
		calculate()
		answer = raw_input('Do you want to perform other calculation ? (yes/no):')

def exercice6():
	"""############################ Exercice 6 ############################################"""
	print "[Exercice 6]"

	# 1. randomly generates a number between 0 and 100

	guess=int(100*rand.random())


	counter = 0
	goOn = True
	while counter < 10 and goOn:
	    player = int(raw_input('Enter a number to play :'))
	    if guess > player:
	        print 'more'
	        counter = counter+1
	    elif guess < player:
	        print 'less'
	        counter = counter+1
	    else:
	        goOn = False

	#4. If the users has not guessed the number after the 10 th round, the system return You loose
	if goOn:
	    print 'You loose'
	else :
		print 'Congratulations!!'


exercice1()
exercice2()
exercice3()
exercice4()
exercice5()
exercice6()

