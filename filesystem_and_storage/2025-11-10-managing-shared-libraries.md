# managing-shared-libraries

*Date:* 2025-11-10

## Overview
`ldd <binary>` is a command that lists dynamic dependencies and prints the shared libraries required by each program or library, useful options for ldd is `ldd –version`, shows version of ldd, `ldd -v <binary>`, shows all information, including symbol versioning, `ldd -u <binary>`, list unused direct dependencies.
A binary is any non-text file, usually compiled machine code and an executable is a binary or script that can be executed by the OS.
A specific type of binary is an executable such as the commands located inside /bin that the operating system can run directly because the file has execute permission, is in a recognized executable format such as either ELF (Executable and Linkable Format) or Script with a shebang (e.g. #!/bin/bash)
This is useful for checking which shared libraries a program uses, to verify library versions and paths, diagnose missing dependencies like if a required .so file is missing ldd will show “not found” next to the dependency, understand binary portability which is checking whether a binary will run on another system, security auditing such as identifying unwanted or unexpected dynamic links.

SECURITY RISK:
Never run ldd on untrusted binaries, ldd works by setting the LD_TRACE_LOADED_OBJECTS environment variable and executing the binary in special code. A malicious binary could exploit this to run arbitrary code. To analyse an untrusted binary safely, use: `objdump -p <file> | grep NEEDED or readelf -d <file> | grep NEEDED` which will read the binary directly without executing any code.
With ldd you can find a library you’re curious of, use find, starting from the /usr where most libraries are located and search for the specific library to find its path using a command like this, `sudo find /usr -name <library>`.
This is used when you want to locate a file by name or pattern, you're not sure where a library or file physically resides, and/or your troubleshooting path or installation issues.
'ldconfig' updates the library cache system-wide and can be combined with a specific library location to update those
You can use this to also query with the '-p' flag which will print the current cache of known libraries.
This is used when you've installed new libraries under /usr/local/lib or another nonstandard location or if the program says “error while loading shared libraries: libXYZ.so: cannot open shared object file or directory”. You can also use the '-v' flag to output everything verbosely and see what it is doing when updating the caches



## Key Commands
```bash
ldd <binary>
objdump -p <file> | grep NEEDED
readelf -d <file> | grep NEEDED
ldconfig
```

## Insights
`ldd` reveals what a program depends on. A binary is a compiled file, an executable is one that can run. Executables come in specific formats. `ldd` is crucial for troubleshooting and auditing. Security Warning, Dont run ldd on untrusted binaries. You can find library files with find and manage libraries with `ldconfig`. `ldd` is like a nutrition label for programs, binary is the ingredient mixture. Executable is a cooked meal ready to eat, and ELF/Shebang is a blueprint or interpreter note. Treat `ldd` as tasting mystery soup and find as a flashligh in a garage. `ldconfig` is like a refresh for your contacts list.

## Reflection
> Really interesting the security risk that comes with ldd and how it executes binary code in a special mode which can be exploited by a malicious program.
