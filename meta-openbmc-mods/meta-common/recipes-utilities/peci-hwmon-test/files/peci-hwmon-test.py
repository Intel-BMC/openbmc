#!/usr/bin/python

import glob
import os
import sys
import time

if len(sys.argv) == 1:
    cpuno = 0
else:
    cpuno = int(sys.argv[1])

hwmon_path = '/sys/class/hwmon'
cputemp_name_match = '{}{}'.format('peci_cputemp.cpu', cpuno)
dimmtemp_name_match = '{}{}'.format('peci_dimmtemp.cpu', cpuno)

dimmtemp_path = ''

os.chdir(hwmon_path)

for dirpath, dirnames, files in os.walk(hwmon_path):
    for d in dirnames:
        try:
            with open('{}/{}'.format(d, 'name')) as f:
                hwmon_name = f.read().strip()
                if hwmon_name == cputemp_name_match:
                    cputemp_path = os.path.abspath(d)
                    cputemp_name = hwmon_name
                elif hwmon_name == dimmtemp_name_match:
                    dimmtemp_path = os.path.abspath(d)
                    dimmtemp_name = hwmon_name
        except:
            continue

if not cputemp_path:
    print "Can't find the " + cputemp_name_match
    quit()

try:
    while True:
        os.system('clear')
        os.chdir(cputemp_path)

        print '{}/{}: {}'.format(hwmon_path, cputemp_path, cputemp_name)
        if dimmtemp_path:
            print '{}/{}: {}'.format(hwmon_path, dimmtemp_path, dimmtemp_name)

        print
        print 'Package temperature'
        for input in glob.glob('temp[1-5]_input'):
            try:
                with open(input) as f:
                    val = f.read().strip()
            except IOError:
                val = 0
            try:
                with open(input.replace('input', 'label')) as l:
                    name = l.read().strip()
            except IOError:
                name = ''
            print '{:11s}:{:3d}.{:03d}'.format(
                name, (int(val) / 1000), (int(val) % 1000))

        print
        print 'Core temperature'
        count = 0
        for input in glob.glob('temp[!1-5]_input'):
            try:
                with open(input) as f:
                    val = f.read().strip()
            except IOError:
                val = 0
            try:
                with open(input.replace('input', 'label')) as l:
                    name = l.read().strip()
            except IOError:
                name = ''
            print ('{:9s}:{:3d}.{:03d}'.format(
                name, (int(val) / 1000), (int(val) % 1000))),
            count += 1
            if count % 3 == 0:
                print
            else:
                print ('\t'),
        for input in glob.glob('temp??_input'):
            try:
                with open(input) as f:
                    val = f.read().strip()
            except IOError:
                val = 0
            try:
                with open(input.replace('input', 'label')) as l:
                    name = l.read().strip()
            except IOError:
                name = ''
            print ('{:9s}:{:3d}.{:03d}'.format(
                name, (int(val) / 1000), (int(val) % 1000))),
            count += 1
            if count % 3 == 0:
                print
            else:
                print ('\t'),
        print

        if dimmtemp_path:
            os.chdir(dimmtemp_path)
            print
            print 'DIMM temperature'
            count = 0
            for input in glob.glob('temp*_input'):
                try:
                    with open(input) as f:
                        val = f.read().strip()
                except IOError:
                    val = 0
                try:
                    with open(input.replace('input', 'label')) as l:
                        name = l.read().strip()
                except IOError:
                    name = ''
                print ('{:9s}:{:3d}.{:03d}'.format(
                    name, (int(val) / 1000), (int(val) % 1000))),
                count += 1
                if count % 3 == 0:
                    print
                else:
                    print ('\t'),
            print
        else:
            os.chdir(hwmon_path)
            for dirpath, dirnames, files in os.walk(hwmon_path):
                for d in dirnames:
                    try:
                        with open('{}/{}'.format(d, 'name')) as f:
                            hwmon_name = f.read().strip()
                            if hwmon_name == dimmtemp_name_match:
                                dimmtemp_path = os.path.abspath(d)
                                dimmtemp_name = hwmon_name
                    except:
                        continue

        time.sleep(1)
except KeyboardInterrupt:
    print " exiting..."
