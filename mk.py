#!/usr/bin/env python3

import os,sys,subprocess,os.path
from assets.tools import exec, patch

#
# main functions
#


def deps_win32():
    exec('rustup target add i686-pc-windows-msvc')

def full_mar():
    with open('version','r') as file:
        version = file.read().rstrip()
        with open('source_release','r') as file:
            source_release = file.read().rstrip()
            os.chdir('librewolf-{}-{}'.format(version,source_release))

            # see https://firefox-source-docs.mozilla.org/taskcluster/setting-up-an-update-server.html

            objdir = 'obj-x86_64-pc-mingw32'
            mar_output_path = 'MAR'
            # version already set
            channel = 'default'

            exec('mkdir -p MAR') # output folder           
            exec('touch {}/dist/firefox/precomplete'.format(objdir))
            exec('MAR={}/dist/host/bin/mar.exe MOZ_PRODUCT_VERSION={}-{} MAR_CHANNEL_ID={} ./tools/update-packaging/make_full_update.sh {} {}/dist/firefox'.format(objdir,version,source_release,channel,mar_output_path,objdir))

            # create config.xml
            mar_name = 'output.mar'
            
            # sha512sum
            hash_sha512 = ''
            exec("cat MAR/{} | sha512sum | awk '{}' > tmpfile78419".format(mar_name,'{print $1}'))
            with open('tmpfile78419', 'r') as tmpfile:
                data = tmpfile.read().rstrip()
                hash_sha512 = data
            exec('rm -f tmpfile78419')

            # size in bytes
            size = os.path.getsize('MAR/{}'.format(mar_name))
            mar_version = '2000.0a1'
            build_id = '21181002100236'
            update_url = 'http://127.0.0.1:8000' # no trailing slash
            config_xml = '''<?xml version="1.0" encoding="UTF-8"?>
<updates>
    <update type="minor" displayVersion="{}" appVersion="{}" platformVersion="{}" buildID="{}">
        <patch type="complete" URL="{}/{}" hashFunction="sha512" hashValue="{}" size="{}"/>
    </update>
</updates>
'''.format(mar_version,mar_version,mar_version,build_id,update_url,mar_name,hash_sha512,size)
            textfile = open('MAR/update.xml','w')
            textfile.write(config_xml)
            textfile.close()

# restore state
            os.chdir('..')
    pass





def fetch():
    exec('wget -q -O version https://gitlab.com/librewolf-community/browser/source/-/raw/main/version')
    exec('wget -q -O source_release https://gitlab.com/librewolf-community/browser/source/-/raw/main/release')
    exec('wget -q -O librewolf-$(cat version)-$(cat source_release).source.tar.gz.sha256sum https://gitlab.com/librewolf-community/browser/source/-/jobs/artifacts/main/raw/librewolf-$(cat version)-$(cat source_release).source.tar.gz.sha256sum?job=Build')
    exec('wget -q -O librewolf-$(cat version)-$(cat source_release).source.tar.gz https://gitlab.com/librewolf-community/browser/source/-/jobs/artifacts/main/raw/librewolf-$(cat version)-$(cat source_release).source.tar.gz?job=Build')
    exec('sha256sum -c librewolf-$(cat version)-$(cat source_release).source.tar.gz.sha256sum')
    exec('cat librewolf-$(cat version)-$(cat source_release).source.tar.gz.sha256sum')






    
def build(debug=False):
    
    exec('rm -rf librewolf-$(cat version)-$(cat source_release)')
    exec('tar xf librewolf-$(cat version)-$(cat source_release).source.tar.gz')
    
    with open('version','r') as file:
        version = file.read().rstrip()
        with open('source_release','r') as file:
            source_release = file.read().rstrip()
            os.chdir('librewolf-{}-{}'.format(version,source_release))

            # patches
            if debug:
                exec('cp -v ../assets/mozconfig.windows.debug mozconfig')
            else:
                exec('cp -v ../assets/mozconfig.windows mozconfig')

            # patches for windows only
            patch('../assets/package-manifest.patch')
            #patch('../assets/disable-verify-mar.patch')
            patch('../assets/tryfix-reslink-fail.patch')
            patch('../assets/fix-l10n-package-cmd.patch')
            exec("cp -v ../assets/private_browsing.VisualElementsManifest.xml ../assets/PrivateBrowsing_150.png ../assets/PrivateBrowsing_70.png browser/branding/librewolf")

            # perform the build and package.
            exec('./mach build')
            exec('./mach package')
            os.chdir('..')


def artifacts():

    # Trying to fix issue #146 -> https://gitlab.com/librewolf-community/browser/windows/-/issues/146
    # (keep this False for now)
    _with_app_name = False
    
    with open('version','r') as file1:
        version = file1.read().rstrip()
        source_release = ''
        with open('source_release','r') as file3:
            source_release = file3.read().rstrip()
        buildzip_filename = 'firefox-{}-{}.en-US.win64.zip'.format(version,source_release)
        if _with_app_name:
            buildzip_filename = 'librewolf-{}-{}.en-US.win64.zip'.format(version,source_release)
        exec('cp -v librewolf-{}-{}/obj-x86_64-pc-mingw32/dist/{} .'.format(version,source_release,buildzip_filename))
        exec('cp -v librewolf-{}-{}/obj-x86_64-pc-mingw32/dist/install/sea/firefox-{}-{}.en-US.win64.installer.exe .'.format(version,source_release,version,source_release))
        exec('rm -rf work && mkdir work')
        os.chdir('work')
        exec('unzip -q ../{}'.format(buildzip_filename))
        if not _with_app_name:
            exec('mv firefox librewolf')
        os.chdir('librewolf')
        if not _with_app_name:
            exec('mv firefox.exe librewolf.exe')
        os.chdir('..')
        os.chdir('..')

        # let's get 'release'.
        with open('release','r') as file2:
            release = file2.read().rstrip()
            source_release = ''
            with open('source_release','r') as file5:
                source_release = file5.read().rstrip()
            if release == '1' :
                full_version = '{}-{}'.format(version,source_release)
            else:
                full_version = '{}-{}-{}'.format(version,source_release,release)

            # let's copy in the .ico icon.
            exec('cp -v assets/librewolf.ico work/librewolf')

            # Let's make the portable zip first.
            if False:
                os.chdir('work')
                exec('rm -rf librewolf-{}'.format(version))
                os.makedirs('librewolf-{}/Profiles/Default'.format(version), exist_ok=True)
                os.makedirs('librewolf-{}/LibreWolf'.format(version), exist_ok=True)
                exec('cp -r librewolf/* librewolf-{}/LibreWolf'.format(version))
                exec('wget -q -O librewolf-{}/librewolf-portable.exe https://gitlab.com/librewolf-community/browser/windows/uploads/64b929c39999d00efb56419f963e1b22/librewolf-portable.exe'.format(version))
                zipname = 'librewolf-{}.en-US.win64.zip'.format(full_version)
                exec("rm -f ../{}".format(zipname))
                exec("zip -qr9 ../{} librewolf-{}".format(zipname,version))            
                os.chdir('..')

            # With that out of the way, we need to create the main nsis setup.
            os.chdir('work')
            exec("mkdir x86-ansi")
            exec("wget -q -O ./x86-ansi/nsProcess.dll https://shorsh.de/upload/2y9p/nsProcess.dll")
            exec("wget -q -O ./vc_redist.x64.exe https://aka.ms/vs/17/release/vc_redist.x64.exe")
            setupname = 'librewolf-{}.en-US.win64-setup.exe'.format(full_version)
            exec('sed \"s/pkg_version/{}/g\" < ../assets/setup.nsi > tmp.nsi'.format(full_version))
            exec('cp -v ../assets/librewolf.ico .')
            exec('cp -v ../assets/banner.bmp .')
            exec('makensis -V1 tmp.nsi')
            exec('rm -rf tmp.nsi librewolf.ico banner.bmp x86-ansi')
            exec("mv {} ..".format(setupname))
            os.chdir('..')

            # Latest addition: better portable app
            os.chdir('work')

            exec('rm -rf librewolf-{}'.format(version))
            os.makedirs('librewolf-{}/Profiles/Default'.format(version), exist_ok=True)
            os.makedirs('librewolf-{}/LibreWolf'.format(version), exist_ok=True)
            exec('cp -r librewolf/* librewolf-{}/LibreWolf'.format(version))
            # on gitlab: https://gitlab.com/ltGuillaume
            exec('"/c/Program Files/Git/bin/git.exe" clone https://github.com/ltGuillaume/LibreWolf-Portable')
            exec('cp -v LibreWolf-Portable/LibreWolf-Portable.* LibreWolf-Portable/*.exe librewolf-{}/'.format(version))
            os.chdir('librewolf-{}'.format(version))
            # installed from: https://www.autohotkey.com/
            exec('echo \\"c:/Program Files/AutoHotkey/Compiler/Ahk2Exe.exe\\" /in LibreWolf-Portable.ahk /icon LibreWolf-Portable.ico > tmp.bat')
            exec('cmd /c tmp.bat')
            exec('rm -f tmp.bat')
            # let's remove the ahk and icon and embedded executables
            exec('rm -f LibreWolf-Portable.ahk LibreWolf-Portable.ico dejsonlz4.exe jsonlz4.exe')
            os.chdir('..')

            # issue #244
            os.chdir('librewolf-{}/LibreWolf'.format(version))
            exec('wget -q -O ./vc_redist.x64-extracted.zip "https://gitlab.com/librewolf-community/browser/windows/uploads/7106b776dc663d985bb88eabeb4c5d7d/vc_redist.x64-extracted.zip"')
            exec('unzip vc_redist.x64-extracted.zip')
            exec('rm vc_redist.x64-extracted.zip')
            os.chdir('../..')

            # make final zip
            pa_zipname = 'librewolf-{}.en-US.win64-portable.zip'.format(full_version)
            exec("rm -f ../{}".format(pa_zipname))
            exec("zip -qr9 ../{} librewolf-{}".format(pa_zipname,version))            
            
            os.chdir('..')




# Utility function to upload() function.
def do_upload(filename,token):
    exec('echo _ >> upload.txt')
    exec('curl --request POST --header \"PRIVATE-TOKEN: {}\" --form \"file=@{}\" \"https://gitlab.com/api/v4/projects/13852981/uploads\" >> upload.txt'.format(token,filename),False)
    exec('echo _ >> upload.txt')


def upload(token):

    with open('version','r') as file1:
        version = file1.read().rstrip()
        with open('release','r') as file2:
            release = file2.read().rstrip()
            
            source_release = ''
            with open('source_release','r') as file3:
                source_release = file3.read().rstrip()
                
            if release == '1' :
                full_version = '{}-{}'.format(version,source_release)
            else:
                full_version = '{}-{}'.format(version,source_release,release)

            # Files we need to upload..
            if False:
                zip_filename = 'librewolf-{}.en-US.win64.zip'.format(full_version)
            setup_filename = 'librewolf-{}.en-US.win64-setup.exe'.format(full_version)
            pazip_filename = 'librewolf-{}.en-US.win64-portable.zip'.format(full_version)
            if False:
                exec('sha256sum {} {} {} > sha256sums.txt'.format(setup_filename,zip_filename,pazip_filename))
            else:
                exec('sha256sum {} {} > sha256sums.txt'.format(setup_filename,pazip_filename))

            # create signatures
            exec('gpg --yes --detach-sign {}'.format(setup_filename))
            exec('echo Press any key... ; cat > /dev/null')
            exec('gpg --yes --detach-sign {}'.format(pazip_filename))

            # upload everything
            exec('rm -f upload.txt')
            do_upload(setup_filename,token)
            do_upload(pazip_filename,token)
            do_upload('{}.sig'.format(setup_filename),token)
            do_upload('{}.sig'.format(pazip_filename),token)
            do_upload('sha256sums.txt',token)

            
#
# parse commandline for commands
#

help_msg = '''
Use: ./mk.py <command> ...

commands:
  fetch
  build
  build-debug
  artifacts
  upload <token>

'''

done_something = False

in_upload=False
for arg in sys.argv:
    if in_upload:
        upload(arg)
        done_something=True
    elif arg == 'fetch':
        fetch()
        done_something = True
    elif arg == 'build':
        build()
        done_something = True
    elif arg == 'build-debug':
        build(True)
        done_something = True
    elif arg == 'artifacts':
        artifacts()
        done_something = True
    elif arg == 'full-mar':
        full_mar()
        done_something = True
    elif arg == 'upload':
        in_upload = True
    else:
        if arg == sys.argv[0]:
            pass
        else:
            print(help_msg)
            sys.exit(1)


        
if done_something:
    sys.exit(0)
    
print(help_msg)
sys.exit(1)
