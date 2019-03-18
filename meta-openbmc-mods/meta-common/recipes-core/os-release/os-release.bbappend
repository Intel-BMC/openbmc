# WARNING!
#
# These modifications to os-release disable the bitbake parse
# cache (for the os-release recipe only).  Before copying
# and pasting into another recipe ensure it is understood
# what that means!

def irun_git(d, oeroot, git_cmd, **kwargs):
    err = None
    try:
        cmd = 'git --work-tree {} --git-dir {}/.git {}'.format(oeroot, oeroot, git_cmd)
        ret, err = bb.process.run(cmd, **kwargs)
        if err is not None:
            ret += err
    except bb.process.ExecutionError as e:
        ret = ''
        if e.stdout is not None:
            ret += e.stdout
        if e.stderr is not None:
            ret += e.stderr
    except Exception as e:
        ret = str(e)
    return ret.strip('\n')

def repo_status(d, f, repo, tagargs):
    import subprocess

    cmd_list = [['HEAD', 'rev-parse HEAD'],
                ['TAG', 'describe {} --dirty --long'.format(tagargs)],
                ['STATUS', 'status -sb']]

    f.write(('\n# REPOSITORY: {} '.format(os.path.basename(repo))).ljust(80, '+') + '\n')
    for item in cmd_list:
        f.write('# {}: '.format(item[0]))
        sb = irun_git(d, repo, item[1])
        if sb:
            sb_lines = sb.split('\n')
            if len(sb_lines) == 1:
                f.write(sb_lines[0])
            else:
                f.write('\n# ' + '\n# '.join(sb_lines))
        f.write('\n')

python() {
    corebase = d.getVar('COREBASE', True)
    mibase = os.path.join(corebase, 'openbmc-meta-intel')
    obmc_vers = irun_git(d, corebase, 'describe --dirty --long')
    meta_vers = irun_git(d, mibase, 'rev-parse HEAD')[0:7]
    version_id = '{}-{}'.format(obmc_vers, meta_vers)
    if version_id:
        d.setVar('VERSION_ID', version_id)
        versionList = version_id.split('-')
        version = '{}-{}'.format(versionList[0], versionList[1])
        d.setVar('VERSION', version)

    build_id = irun_git(d, corebase, 'describe --abbrev=0')
    if build_id:
        d.setVar('BUILD_ID', build_id)
}

OS_RELEASE_FIELDS_append = " BUILD_ID"

python do_compile_append () {
    import glob
    with open(d.expand('${B}/os-release'), 'a') as f:
        corebase = d.getVar('COREBASE', True)
        f.write('\n# Build Configuration Details\n')
        repo_status(d, f, corebase, '')
        repo_status(d, f, os.path.join(corebase, 'openbmc-meta-intel'), '--tags')
        appends_dir = os.path.join(d.getVar('TOPDIR', True), 'workspace', 'appends')

        for fn in glob.glob(os.path.join(appends_dir, '*.bbappend')):
            with open(fn, 'r') as bb_f:
                for line in bb_f:
                    if line.startswith('# srctreebase: '):
                        srctreebase = line.split(':', 1)[1].strip()
                        repo_status(d, f, srctreebase, '--tags')
}


# Ensure the git commands run every time bitbake is invoked.
BB_DONT_CACHE = "1"

# Make os-release available to other recipes.
SYSROOT_DIRS_append = " ${sysconfdir}"
