####################################################################
#
# Calculates the absolute phase shift (sound delay)of two wave 
# files specified on the command line as such;
# ./delay file1 file2 [samplerate]
# If no sample rate is specified - a default of 16000 is used
#
# The format of the input file is expected to be:
#  samplenumber sample
# With samples seperated by a newline.
# 
# This implementation is shamelessly stolen and adapted from:
# http://stackoverflow.com/questions/6157791/find-phase-difference-between-two-inharmonic-waves
# Credits go out to deprecated.

import os
import sys
import numpy
import wave, struct
from scipy.signal import correlate

samplerate = 16000.0

if len(sys.argv) < 3:
    print "Calculates the absolute phase shift of two wave files"
    print "Usage: " + sys.argv[0] + " wavefile1 wavefile2 [samplerate]"
    print "If no sample rate is specified, a default of 16000 is used"
    sys.exit(1)
    
if len(sys.argv) == 4:
    samplerate = float (sys.argv[3]) 

sampleFilename1 = sys.argv[1]+".calc.tmp"
sampleFilename2 = sys.argv[2]+".calc.tmp"

# Open the wave file handles, and their corresponding sample files.
waveFile1 = wave.open(sys.argv[1], 'r')
waveFile2 = wave.open(sys.argv[2], 'r')
sampleFile1 = PJSUA_log=open(sampleFilename1, 'w')
sampleFile2 = PJSUA_log=open(sampleFilename2, 'w')

# If there is a need to read in the complete dataset.
#length = waveFile1.getnframes()

# To save CPU cycles, we only use the first 20k samples.
for i in range(0,20000):
    waveData1 = waveFile1.readframes(1)
    waveData2 = waveFile2.readframes(1)
    
    data1 = struct.unpack("<h", waveData1)
    data2 = struct.unpack("<h", waveData2)
    print >> sampleFile1, str(i) + " " + str (int(data1[0]))
    print >> sampleFile2, str(i) + " " + str (int(data2[0]))

sampleFile1.close()
sampleFile2.close()

# Load datasets, taking mean of 100 values in each table row
A = numpy.loadtxt(sampleFilename1)[:,1:].mean(axis=1)
B = numpy.loadtxt(sampleFilename2)[:,1:].mean(axis=1)

nsamples = A.size

# regularize datasets by subtracting mean and dividing by s.d.
A -= A.mean(); A /= A.std()
B -= B.mean(); B /= B.std()

# Put in an artificial time shift between the two datasets
time_shift = 20
A = numpy.roll(A, time_shift)

# Find cross-correlation
xcorr = correlate(A, B)

# delta time array to match xcorr
dt = numpy.arange(1-nsamples, nsamples)

recovered_time_shift = dt[xcorr.argmax()]

#print "Estimated absolute phase shift: %f" % abs((recovered_time_shift/samplerate))
# Just output the number for easy appending to file.
print "%f" % abs((recovered_time_shift/samplerate))


# Cleanup
os.remove(sampleFilename1)
os.remove(sampleFilename2)
