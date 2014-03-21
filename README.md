Black Examples [1]
==================

A collection of examples using the HTTP library Black.


Building
--------

```
make
```

The resulting executables can be found in the directory `bin/`:

- `bin/single_thread_server` is a simple HTTP server listening on port 8080.
  It has three distinct resources:
  1. `/` - reporting its identity.
  2. `/redirect` - redirecting you to another server.
  3. `/stop` - stopping the server.


Testing
-------

```
make test
```

The resulting test reports (in JUnit format) can be found in the directory `tests/results/`.


Dependencies
------------

- GNU Make (make) - for build management.
- Mercurial (hg) - for fetching external sources.
- Black [2] - the library we're demonstrating here.
- Ahven [3] - for unit testing.
- GNAT [4] - since we use GNAT.Sockets to connect to a TCP/IP socket.
- libesl [5] - as Black depends on it.


Links
-----

If you want to find free Ada tools or libraries AdaIC [6] is an excellent
starting point.  You can also take a look at the other source text
repositories belonging to AdaHeads K/S [7] or those belonging to Jacob
Sparre Andersen [8].

1. Source text repository:
   https://github.com/AdaHeads/Black-examples
2. Black:
   https://github.com/AdaHeads/Black
3. Ahven:
   http://www.ahven-framework.org/
4. GNAT:
   http://libre.adacore.com/ - included in all well-assorted operating systems
5. Black:
   https://github.com/AdaHeads/libesl
6. Free Ada Tools and Libraries:
   http://www.adaic.org/ada-resources/tools-libraries/
7. Our repositories on GitHub:
   https://github.com/AdaHeads
8. Jacob Sparre Andersen's repositories on Bitbucket:
   http://repositories.jacob-sparre.dk/

