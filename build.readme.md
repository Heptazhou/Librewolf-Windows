Use: ./build.sh clean | all | [other stuff...]

    fetch            - fetch the tarball.
    extract          - extract the tarball.
    do_patches       - create a mozconfig, and patch the source.
    build            - the actual build.

    artifacts_win    - apply .cfg, build the zip file and NSIS setup.exe installer.
    artifacts_perm   - package as above, but use the permissive config/policies.

# Linux related functions:

    deps_deb	        - install dependencies with apt.
    deps_rpm	        - install dependencies with dnf.
    deps_pkg	        - install dependencies with pkg. (freebsd)
    deps_mac	        - install dependencies with brew. (macOS)

    artifacts_deb       - apply .cfg, create a dist zip file (for debian10).
    artifacts_deb_perm  - include permissive build.
    artifacts_rpm       - apply .cfg, create a dist zip file (for fedora33).
    artifacts_rpm_perm  - include permissive build.

# Generic utility functionality:

    all             - build all, produce all artifacts including -permissive.
    clean           - remove generated cruft.

    mach_env        - create mach build environment.
    rustup	        - perform a rustup for this user.
    git_subs        - update git submodules.
    config_diff     - diff between my .cfg and dist .cfg file. (win10)
    policies_diff   - diff between my policies and the dist policies. (win10)
    git_init        - create .git folder in firefox-87.0 for creating patches.
    mach_run_config - copy librewolf config/policies to enable 'mach run'.

# Cross-compile from linux:

    linux_patches    - the 'do_patches' for linux->win crosscompile.
    linux_artifacts  - standard artifact zip file. perhaps a -setup.exe.
    setup_deb_root   - setup compile environment (root stuff)
    setup_deb_user   - setup compile environmnet (build user)
    setup_rpm_root   - setup compile environment (root stuff)
    setup_rpm_user   - setup compile environmnet (build user)

# Nightly:

    init_mozilla_unified   - use bootstrap.py to grab the latest mozilla-unified.
    set_mozilla_unified    - use mozilla-unified instead of firefox-87.0 source.
    reset_mozilla_unified  - clean mozilla-unified and pull latest git changes.

Documentation is in the build-howto.md. In a docker situation, we'd like
to run something like: 

    ./build.sh fetch extract linux_patches build linux_artifacts

# Installation from linux zip file:

Copy the zip file in your $HOME folder, then:

    unzip librewolf-*.zip
    cd librewolf
    ./register-librewolf

That should give an app icon. You can have it elsewhere and it will work.

# Examples:
  
    For windows, use:
      ./build.sh fetch extract do_patches build artifacts_win
      ./build.sh all

    For debian, use: 
      sudo ./build.sh deps_deb 
      ./build.sh rustup mach_env
      ./build.sh fetch extract do_patches build artifacts_deb

