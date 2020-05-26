import sys

for line in sys.stdin:
  stripped = line.strip()
  stripped = stripped.split()
  result = ""
  count = 0
  for word in stripped:
    if count < 3:
        result += word + ","
        count += 1
    else:
        result += word + " "
  result = result[:-1]
  print(result)
