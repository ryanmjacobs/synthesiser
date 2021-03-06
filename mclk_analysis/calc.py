#!/usr/bin/env python
import math

f = open("potential_freqs.txt", "r")
text = f.read()

freq_str = list(filter(None, text.replace("\n", " ").split(" ")))
freq_num = list(map(float, freq_str))

print(freq_num)

o = {}
for freq in iter(freq_num):
    div = 100/freq
    rem = div - math.floor(div)

    o[freq] = rem

print("")
for freq in iter(o):
    rem = o[freq]

    print("%1.3f Mhz => %0.2f remainder" % (freq, rem))

best = min(o, key=o.get)
print("\nmin remainder: %0.3f => %0.2f remainder" %(best, o[best]))
