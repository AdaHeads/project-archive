# System tests.

Tests aimed to give a good indication on how well the system is performing, and wheter it lives up to
the requirement specified in the protocol and in general.

End-to-end tests are a typical scenario for tests found here.

## Overall requirements 
 - python-unit
 - python websockets
 - PJSUA-python (build manually)
 - Others ...

## Contents

### testcases.py

Performs a peer logon and dials an extension connected to an echo channel, which in this case is extension 8888.
Plays back a wave file found at test-wav/input.wav and outputs the echo to the recordings dir. The name of this
file is the timestamp of test initiation, suffixed by .wav.

#### Requirements
For this test to succeed, it needs; 
 
 - A valid Alice server (specified in config.py)
 - A valid PBX with a corresponding sip account
 - An echo channel configured at the PBX

For the latter, this extension can be added to asterisk's extensions.conf

````
exten => 8888,1,Answer
 same =>      n,Echo()
 same =>      n,Hangup()
````

### util/delay.py

This script detects the phase shift (delay) between two wave files and outputs a floating point number to 
standard output.
The ideas behind this is that we can pickup this value and append to a running statistics file, like so;

  python util/delay.py test-wav/infile.wav recordings/1362756875.76.wav >> delay_statistics

### Requirements

 - scipy
 - numpy
