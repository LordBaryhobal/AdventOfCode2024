with open("res/inputs/day22.txt", "r") as f:
    values = list(map(int, f.read().split("\n")))

calls = 0

def step(a, shift):
    global calls
    calls += 1
    s = (a >> -shift) if shift < 0 else (a << shift)
    return (s ^ a) & 0xffffff

def rand(value):
    b = step(value, 6)
    c = step(b, -5)
    d = step(c, 11)
    return d


total = 0
for v in values:
    for _ in range(2000):
        v = rand(v)
    total += v

print(total)
print(calls)