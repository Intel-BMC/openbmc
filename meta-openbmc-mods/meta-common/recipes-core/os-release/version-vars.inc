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
    import re

    gen = d.getVar('PRODUCT_GENERATION', True)
    if gen is None:
        gen = 'unknown'

    corebase = d.getVar('COREBASE', True)
    mibase = os.path.join(corebase, 'meta-openbmc-mods')
    obmc_vers = irun_git(d, corebase, 'describe --dirty --long')
    if obmc_vers is None:
        raise bb.build.FuncFailed("Missing version tag for openbmc-openbmc")
    d.setVar('OPENBMC_VERSION', obmc_vers)

    obmc_hash = irun_git(d, corebase, 'rev-parse HEAD')
    meta_vers = irun_git(d, mibase,
                         'describe --long --abbrev=6 ' +
                         '--match \'{}-[0-9]*\.[0-9]*\''.format(gen))

    # If no tag, provide default version
    if meta_vers.startswith('fatal:'):
        ver_list = obmc_vers.split('-')
        obmc_tag_list = ver_list[1].split('.')
        obmc_major_revision = 0
        obmc_minor_revision = 0
        obmc_minor_spare = 0
        try:
            obmc_major_revision = int(obmc_tag_list[0])
            obmc_minor_revision = int(obmc_tag_list[1])
            obmc_minor_spare = int(ver_list[2])
        except ValueError:
            bb.warn("Invalid obmc_vers: {}".format(obmc_vers))
        meta_vers = '{}-{}.{}-{}-g{}'.format(gen,obmc_major_revision,
                    obmc_minor_revision,obmc_minor_spare,obmc_hash[0:6])

    meta_hash = irun_git(d, mibase, 'rev-parse HEAD')
    # If no hash, provide default
    if meta_hash.startswith('fatal:'):
        meta_hash = obmc_hash[0:7]
    version_id = '{}-{}'.format(meta_vers, obmc_hash[0:7])
    if version_id:
        d.setVar('VERSION_ID', version_id)
        versionList = version_id.split('-')
        versionList = re.split('-|\.', version_id)
        version = '{}.{}-{}'.format(versionList[0], versionList[1], versionList[2])
        d.setVar('VERSION', version)
        d.setVar('IPMI_MAJOR', versionList[1])
        d.setVar('IPMI_MINOR', versionList[2])
        d.setVar('IPMI_AUX13', hex(min(int(versionList[3]), 0xff)))
        d.setVar('IPMI_AUX14', '0x{}'.format(meta_hash[0:2]))
        d.setVar('IPMI_AUX15', '0x{}'.format(meta_hash[2:4]))
        d.setVar('IPMI_AUX16', '0x{}'.format(meta_hash[4:6]))

    build_id = irun_git(d, mibase, 'describe --abbrev=0')
    if build_id:
        d.setVar('BUILD_ID', build_id)
}
