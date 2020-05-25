import sys

lines = []

print("[")
for line in sys.stdin:
  stripped = line.strip()
  stripped = "\"" + stripped + "\","
  print(stripped)
