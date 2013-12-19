[The Grand AdaHeads Build System](https://github.com/AdaHeads/Build-system)
===============================

This repository is intended to help building all the Ada based
components of our hosted telephone reception management system.

It will fetch and install needed sources or ready-to-install binaries
in the appropriate versions, before attempting to build the system.

In-flux components will automagically be checked out in matching
versions.


Dependencies
------------

  * make (only tested with GNU Make)
  * git
  * svn (subversion)
  * sudo
  * Python
  * Syslog
  * SQLite
  * PostgreSQL
  * libgcrypt(11)-dev


Usage
-----

The command:

    $ make

will install all required Ada specific dependencies (not those on the
list above), and then compile Alice.

To make the installed tools and libraries generally accessible, you
should put this in your shell configuration file:

    export PATH=/usr/gnat/bin:${PATH}
    export LIBRARY_PATH=${LIBRARY_PATH}:/lib/x86_64-linux-gnu:/usr/lib/x86_64-linux-gnu

At this point your system should be ready for continued development of
Alice, libdialplan and libesl.


Licence
-------

This work is distributed under GPLv2.


More
----

If you want to find free Ada tools or libraries
[AdaIC](http://www.adaic.org/ada-resources/tools-libraries/) is an
excellent starting point.

You can also take a look at [our other repositories on
GitHub](https://github.com/AdaHeads).
