import os,sys,subprocess,os.path

bash_loc = 'd:/mozilla-build/msys/bin/bash.exe'
do_zip = False

# native()/bash()/exec() utility functions
def native(cmd,do_print=True):
    sys.stdout.flush()
    if do_print:
        print(cmd)
        sys.stdout.flush()
   
    retval = os.system(cmd)
    if retval != 0:
        sys.exit(retval)

def bash(cmd,do_print=True):
    tmp = []
    tmp += [bash_loc, '-c', cmd]
    sys.stdout.flush()
    if do_print:
        print(cmd)
        sys.stdout.flush()
    
    retval = subprocess.run(tmp).returncode
    if retval != 0:
        sys.exit(retval)

def exec(cmd,do_print=True):
    _native = False
    if not os.path.isfile(bash_loc):
        _native = True
    if _native:
        return native(cmd,do_print)
    return bash(cmd,do_print)

def patch(patchfile):
    cmd = "patch -p1 -i {}".format(patchfile)
    sys.stdout.flush()
    print("\n*** -> {}".format(cmd))
    sys.stdout.flush()
    
    retval = os.system(cmd)
    if retval != 0:
        sys.stdout.flush()
        print("fatal error: patch '{}' failed".format(patchfile))
        sys.stdout.flush()
        sys.exit(retval)


