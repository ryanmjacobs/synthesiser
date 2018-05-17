#!/usr/bin/env python

f = open("potential_freqs.txt", "r")
text = f.read()

freq_str = list(filter(None, text.replace("\n", " ").split(" ")))
freq_num = list(map(float, freq_str))

print(freq_num)
