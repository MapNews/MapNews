import sys

for line in sys.stdin:
  line = line[1:-4]
  line = line.replace("\\", "")
  print(line)