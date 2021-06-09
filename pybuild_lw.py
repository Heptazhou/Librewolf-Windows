




#
# Large multiline strings
#



help_message = """# Use: 

     pybuild [<options>] clean | all | <targets> | <utilities>

# Options:

    -n,--no-execute         - print commands, don't execute them
    -l,--no-librewolf       - skip LibreWolf specific stages.
    -x,--cross              - crosscompile from linux, implies -t win
    -s,--src <src>          - release,nightly,tor-browser
                              (default=release)
    -t,--distro <distro>    - deb,rpm,win (default=win)

# Targets:

    all      - all steps from fetch to producing setup.exe
    clean    - clean everything, including extracted/fetched sources

    fetch               - wget or hg clone or git pull
    extract             - nop if not wget
    lw_do_patches       - [librewolf] patch the source
    build               - build the browser
    lw_post_build       - [librewolf] insert our settings
    package             - package the browser into zip/apk
    lw_artifacts        - [librewolf] build setup.exe

# Utilities:

    git_subs    - git update submodules
    git_init    - put the source folder in a .git repository

    deps_deb    - install dependencies with apt
    deps_rpm    - install dependencies with dnf
    deps_pkg    - install dependencies on freebsd

    rustup      - update rust
    mach_env    - create mach environment
"""
