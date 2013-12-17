The Grand AdaHeads Build System
===============================

This repository is intended to help building all the Ada based components of
our hosted telephone reception management system.

It will fetch and install needed sources or ready-to-install binaries in the
appropriate versions, before attempting to build the system.

In-flux components will (eventually) automagically be checked out in matching
versions.


Licence
-------

This work is distributed under GPLv2.


------------------------------------------------------------------------------

Dependencies
------------

Not much is needed for using this makefile;
  * make (obviously)
  * git (for AWS and Yolk)
  * subversion (for GNATColl)
  * any dependencies for the subprojects obviously still applies.
  * sudo, gksudo, su if you want to install to a system location

Usage
-----

You need to fetch some files from libre.adacore.com/download and place them 
in ./tgz

Specifically:
  * florist-gpl-2012-src.tgz
  * gnat-gpl-2012-x86_64-pc-linux-gnu-bin.tar.gz
  * xmlada-gpl-4.3-src.tgz

Use 
 $ make ada-development 
to get stated.

Or check out the first few lines of the makefile for additional projects.

Put this in your .bashrc/.cshrc/.zshrc - or export them ad-hoc for relevant projects.

export PATH=$PATH:/usr/gnat/bin;
export LIBRARY_PATH=$LIBRARY_PATH:/usr/lib/x86_64-linux-gnu

You should of course change this to fit your system.

Have fun!
