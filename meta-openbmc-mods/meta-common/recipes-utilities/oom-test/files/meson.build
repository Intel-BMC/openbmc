project(
    'oom-test',
    'c',
    default_options: [
        'warning_level=3',
        'werror=true',
        'c_std=c11'
    ],
    license: 'Apache-2.0',
    version: '0.1',
)
project_description = 'OOM (Out Of Memory) Test Application'

executable(
    'oom-test',
    [
        'oom-test.c',
    ],
    install: true,
    install_dir: get_option('bindir')
)
