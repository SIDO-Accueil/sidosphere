#!/usr/bin/python3

i = 0
f = open('dump_file', 'a')
max_scan = input('How many barecode do you have to scan ? ')
while i < int(max_scan):
    f.write(input('Enter a barecode: '))
    f.write('\n')
    i += 1
f.close()
