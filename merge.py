import sys
# merge content of file, appending last column in each segment to the first
def mergefile(filen):
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
  out = open('output.txt', 'w')
  for line in lines:
      #print line[0:35]
      out.write(line[4:] + "\n")
  out.close()

#filename = "generated_file/out.txt"
mergefile('out.txt');
