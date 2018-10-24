import sys

# delete the first line of the output file
inputname = raw_input("input file name: ")
def delete_line(num):
  #num = 1
  with open('generated_file/out.txt', 'r') as fr:
      lines = fr.readlines()
      if num in range(len(lines)):
        del lines[num-1]

  with open('generated_file/out.txt', 'w') as fw:
      fw.writelines(lines)


# merge content of file, appending last column in each segment to the first
def mergefile(filen, outputfile):
  try:
     f = open(filen,'r')
  except Exception as e:
    print "Could not copy file %s " % (filen)
    print e
    sys.exit(3)


  lines = []

  firstPass = True
  counter = 0

  for line in f:
      try:
          line = line.strip()
          columns = line.split()
          name = columns[3]

          if firstPass:
              lines.append(line)
          else:
              lines[counter] += ' ' + name
          counter += 1

      except IndexError:
          counter = 0
          firstPass = False

  f.close()
  out = open(outputfile, 'w')
  if inputname == 'shift':
    i = 9
  else:
    i = 5
  for line in lines:
      #print line[0:35]
      out.write(line[i:] + "\n")
  out.close()


def main():

  #inputname = raw_input("input file name: ")
  inputFile = "sim_generated_file/"+inputname+".txt"
  outputFile = "sim_generated_file/"+inputname+"_output.txt"
  mergefile(inputFile, outputFile)

if __name__== "__main__":
  main()
"sim_generated_file/out.txt"
