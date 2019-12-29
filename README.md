# sshlog - professional log viewer for ssh protocol 
## Introduction
All authentication logs is store in /var/log/auth.log. This program view all ssh logs such as ssh login and ssh attack in fancy table.

The project page is located at https://github.com/e2ma3n/sshlog

## Why we should use sshlog program ?

- Because i need to see ssh attack in my server
- Because i need to monitor users login in my server
- etc


## What distributions are supported ?
All popular linux distributions such as debian and Ubuntu

| Distribution | Version |
| ---------- | ----------- |
| Debian     | 10.x |
| Debian     | 9.x |
| Debian     | 8.x |
| Ubuntu     | 12.04.x |
| Ubuntu     | 16.04.x |
| Ubuntu     | 18.04.x |


## Dependencies

| Dependency | Description |
| ---------- | ----------- |
| python-pandas   | pandas is an open source, BSD-licensed library providing high-performance, easy-to-use data structures and data analysis tools for the Python programming language. |
| python-tabulate | Pretty-print tabular data in Python, a library and a command-line utility. |
| tree            | list contents of directories in a tree-like format. |
| rm              | remove files or directories. |
| mkdir           | make directories. |
| grep            | grep  searches  the  named  input FILEs for lines containing a match to the given PATTERN. |
| ls              | List information about the FILEs (the current directory by default). |
| cat             | concatenate files and print on the standard output. |
| paste           | Write lines consisting of the sequentially corresponding lines from each FILE, separated by TABs, to standard output. |
| cut             | Print selected parts of lines from each FILE to standard output. |
| tr              | Translate, squeeze, and/or delete characters from standard input, writing to standard output. |

## How to get source code ?
You can download and view source code from github : https://github.com/e2ma3n/sshlog

Also to get the latest source code, run following command:
```
# git clone https://github.com/e2ma3n/sshlog.git
```
This will create sshlog directory in your current directory and source files are stored there.

## How to install dependencies on debian ?
By using apt-get command; for example :
```
# apt-get install python-pandas
# apt-get install python-tabulate
```

## How to install sshlog ?

```
# git clone https://github.com/e2ma3n/sshlog.git
# mv sshlog.sh /usr/bin/sshlog
# chmod +x /usr/bin/sshlog```
```

## How to use sshlog ?
just open terminal and run sshlog

```
# sshlog
```

## How to uninstall ?

```
# rm -f /usr/bin/sshlog
```


## Notes :
	0. run this program just using root user or sudo

## License
This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
