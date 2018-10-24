import os
#from randomGenrate import *
#import randomGenrate
from  merge import *

def main():

	#generate_pattern_t(test_l,bit_l)

	os.system("vsim -do " + "simulate.do")
	filename = "sim_generated_file/out.txt"
	outputfile = "sim_generated_file/output.txt"
	mergefile(filename, outputfile)

if __name__== "__main__":
  main()
