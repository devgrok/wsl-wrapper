#!/usr/bin/python3
#
# This script calls a command from linux, converting any arguments from windows to linux before calling
# It then takes commands from stdin, converting space seperated arguments that it detects as windows paths
# This is to allow repl like tools to be used from windows but running in linux (i.e. for ghc-mod from Intellij)
#
import subprocess
import pty
import os
import sys
import re
import io
from time import sleep

def convert_path(x):
    if re.search(r'^[a-zA-Z]:\\', x):
        return subprocess.getoutput("wslpath '" + x + "'")
    elif re.search(r'^[a-zA-Z]:/', x):
        return subprocess.getoutput("wslpath '" + x + "'")
    elif x.startswith("~"):
        return os.path.expanduser(x)
    elif x.startswith("$"):
        return os.path.expandvars(x)
    else:
        return x

#args = sys.argv[1:]
args = [convert_path(x) for x in sys.argv[1:]]

master, slave = pty.openpty()
subproc = subprocess.Popen(args, shell=False, stdin=slave, stdout=sys.stdout.fileno(), stderr=sys.stderr.fileno())
stdin_handle = io.TextIOWrapper(sys.stdin.buffer)
subin_handle = os.fdopen(master,'wb',buffering=0)


sleep(1)
while subproc.poll() is None:
    line = stdin_handle.readline()
    items = line.split(" ")
    items = map(convert_path, items)
    new_line = " ".join(items)
    subin_handle.write(new_line.encode())
    sleep(1)

subin_handle.close()
