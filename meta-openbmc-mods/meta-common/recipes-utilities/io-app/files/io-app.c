/*
// Copyright (c) 2017 Intel Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// Abstract:   map io region to read or write to HW registers
//
*/

#define _GNU_SOURCE
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <termios.h>
#include <ctype.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/mman.h>

static int quiet = 0;

static int dump(unsigned long phys, void *addr, size_t len)
{
    const uint32_t *ubuf = addr;
    unsigned int wd = 0, l, iv;
    unsigned char *h, *a;
    char line[256];
    static const char itoh[] = "0123456789abcdef";

    /*  0         1         2         3         4         5         6
     *  0123456789012345678901234567890123456789012345678901234567890123456789
     *  00000000: 00000000 00000000 00000000 00000000  ................
     */
    while (wd < len)
    {
        memset(line, ' ', sizeof(line));
        sprintf(line, "%08lx: ", phys + (wd*sizeof(uint32_t)));
        a = (unsigned char*)&line[47];
        h = (unsigned char*)&line[10];
        for (l=0; l<4 && (l+wd)<len; l++)
        {
            uint32_t v = *ubuf++;
            for (iv=0; iv<sizeof(v); iv++)
            {
                uint8_t b = v >> (8*((sizeof(v)-1)-iv));
                *h++ = itoh[b>>4];
                *h++ = itoh[b&0xf];
                if (isprint(b))
                    *a++ = (char)b;
                else
                    *a++ = '.';
            }
            *h++ = ' ';
        }
        *a++ = '\n';
        *a = 0;
        wd += l;
        fputs(line, stdout);
    }
    return wd;
}


struct mapping
{
    unsigned long phys;
    void *virt;
    size_t len;
};

static struct mapping *maps = NULL;
static int nr_maps = 0;

static void unmap_all(void)
{
    int i;
    for (i=0; i<nr_maps; i++)
    {
        if (maps[i].virt)
            munmap(maps[i].virt, maps[i].len);
        maps[i].virt = NULL;
    }
}

int add_a_map(unsigned long phys, void *virt, size_t len)
{
    void *new_maps;
    new_maps = realloc(maps, (nr_maps + 1) * sizeof(struct mapping));
    if (!new_maps)
    {
        unmap_all();
        munmap(virt, len);
    }
    else
    {
        maps = new_maps;
        maps[nr_maps].phys = phys;
        maps[nr_maps].virt = virt;
        maps[nr_maps].len = len;
        nr_maps++;
        return 0;
    }
    return -1;
}

static void *map_fd(int fd, off_t offset, size_t len, int mode, int flags)
{
    void *mapped_at;
    unsigned long phys = -1;

    if (offset != -1)
        phys = offset;
    else
        offset = 0;

    mapped_at = mmap(NULL, len, mode, flags, fd, offset);
    if (mapped_at != MAP_FAILED)
    {
        if (add_a_map(phys, mapped_at, len) != 0)
        {
            mapped_at = MAP_FAILED;
        }
    }

    return mapped_at;
}

static void *map_file(const char *fname, size_t *len, int mode, int flags)
{
    int fd;
    struct stat sb;
    void *ptr;
    int fmode;

    if (mode & PROT_WRITE)
        fmode = O_RDWR;
    else
        fmode = O_RDONLY;

    fd = open(fname, fmode);
    if (fd < 0)
        return MAP_FAILED;

    if (*len == 0)
    {
        fstat(fd, &sb);
        *len = sb.st_size;
    }
    ptr = map_fd(fd, -1, *len, mode, flags);
    close(fd);
    return ptr;
}

static int load_maps(const char *cmap_str, size_t mlen)
{
    char *tmp_sa = NULL, *tmp_sl = NULL, *endptr = NULL;
    const void *mapped = NULL;
    int ret = 0;
    const char *delim = "\r\n\t ,";
    unsigned long addr;
    size_t len;
    char *map_str = NULL, *paddr = NULL, *plen = NULL;
    int fd;

    fd = open("/dev/mem", O_RDWR);
    if (fd < 0)
    {
        return -1;
    }

    len = strlen(cmap_str);
    map_str = (char *)malloc(len + 1);
    if (!map_str)
    {
        close(fd);
        return -1;
    }
    strncpy(map_str, cmap_str, len);
    map_str[len] = '\0';
    paddr = strtok_r(map_str, delim, &tmp_sa);
    while (paddr)
    {
        /* find the next comma or newline */
        if (!strtok_r(paddr, ":", &tmp_sl))
        {
            fprintf(stderr, "malformed map string '%s'\n", paddr);
            goto _loop;
        }
        plen = strtok_r(NULL, ":", &tmp_sl);
        if (!plen)
        {
            goto _loop;
        }
        addr = strtoul(paddr, &endptr, 16);
        if (*endptr)
        {
            fprintf(stderr, "Failed to parse address from '%s'\n", paddr);
            ret = -1;
            break;
        }
        len = strtoul(plen, &endptr, 16);
        if (*endptr)
        {
            fprintf(stderr, "Failed to parse len from '%s'\n", plen);
            ret = -1;
            break;
        }
        if (MAP_FAILED == (mapped = map_fd(fd, addr, len, PROT_READ|PROT_WRITE, MAP_SHARED)))
        {
            fprintf(stderr, "Failed to map %lx +%x\n", addr, len);
            ret = -1;
            break;
        }
        if (!quiet)
            printf("added map: %p (%lx..%lx)\n", mapped, addr, addr+len);
_loop:
        paddr = strtok_r(NULL, delim, &tmp_sa);
    }
    free(map_str);
    close(fd);
    return ret;
}

int md(unsigned long addr, uint32_t unused, size_t len)
{
    int i, j;

    (void)unused;
    for (i=0; i<nr_maps; i++)
    {
        if (-1 == maps[i].phys)
            continue;
        if (maps[i].phys <= addr &&
            (addr + len * sizeof(uint32_t)) < (maps[i].phys + maps[i].len))
        {
            uint32_t *buf, *pv;

            buf = (uint32_t *)malloc(len*sizeof(uint32_t));
            if (!buf)
                return 1;
            pv = (uint32_t *)(maps[i].virt + (addr - maps[i].phys));
            for (j=0; j<len; j++)
                buf[j] = *pv++;

            dump(addr, buf, len);
            free(buf);
            return 0;
        }
    }
    fprintf(stderr, "%lx +%x not in mapped memory\n", addr, len);
    return 1;
}

int mw(unsigned long addr, uint32_t val, size_t len)
{
    int i, j;

    for (i=0; i<nr_maps; i++)
    {
        if (-1 == maps[i].phys)
            continue;
        if (maps[i].phys <= addr &&
            (addr + len * sizeof(uint32_t)) < (maps[i].phys + maps[i].len))
        {
            for (j=0; j<len; j++)
            {
                *((uint32_t*)(maps[i].virt + (addr - maps[i].phys))) = val;
            }
            return 0;
        }
    }
    fprintf(stderr, "%lx +%x not in mapped memory\n", addr, len);
    return 1;
}

char *readline(char *buf, size_t len, FILE *f)
{
    int raw = 0;
    size_t br = 0;
    struct termios tios, orig_tios;

    if (!quiet)
    {
        /* put terminal in raw mode to get unbuffered io */
        if (tcgetattr(fileno(f), &orig_tios) == 0)
        {
            tios = orig_tios;
            tios.c_iflag |= IGNPAR;
            tios.c_iflag &= ~(ISTRIP | INLCR | IGNCR | ICRNL | IXON | IXANY | IXOFF);
            tios.c_lflag &= ~(ISIG | ICANON | ECHO | ECHOE | ECHOK | ECHONL | IEXTEN);
            tios.c_oflag &= ~OPOST;
            tios.c_cc[VMIN] = 1;
            tios.c_cc[VTIME] = 0;
            tcsetattr(fileno(f), TCSADRAIN, &tios);
            raw = 1;
        }
    }
    if (!raw)
    {
        return fgets(buf, len, f);
    }
    /* read in bytes one at a time and echo them */
    while (br < (len-1))
    {
        int c = fgetc(f);
        switch (c)
        {
        case 3: /* ^C */
            br = 0;
            c = '\n';
            break;
        case 4:
            br = 0;
            c = -1;
            break;
        case '\b':
            if (br > 0)
            {
                fputs("\b \b", stdout);
                br--;
            }
            break;
        case '\r':
        case '\n':
            fputs("\r\n", stdout);
            buf[br++] = '\n';
            break;
        case ' '...'~':
            fputc(c, stdout);
            buf[br++] = c;
            break;
            break;
        default:
            break;
        }
        if (c == -1)
        {
            if (br == 0)
                buf = NULL;
            break;
        }
        if (c == '\r' || c == '\n')
            break;
    }
    if (buf)
        buf[br] = 0;

    tcsetattr(fileno(f), TCSADRAIN, &orig_tios);
    return buf;
}

#define MAX_LINE_LEN 4096
int io(void)
{
    const char delim1[] = "\r\n;";
    const char delim2[] = "\t ";
    char line[MAX_LINE_LEN];
    char *command, *cmd, *paddr, *pval, *plen, *endptr;
    char *tmp_s1, *tmp_s2;
    unsigned long addr;
    uint32_t val;
    size_t len;
    int (*fn)(unsigned long, uint32_t, size_t);

    if (!quiet)
        fputs("> ", stdout);
    while (readline(line, MAX_LINE_LEN, stdin) != NULL && *line)
    {
        /* read next line or next command (up to newline or ';') */
        command = strtok_r(line, delim1, &tmp_s1);
        if (!command || strlen(command) == 0)
            goto _command_loop;
        while (NULL != command && strlen(command) > 0)
        {
            cmd = strtok_r(command, delim2, &tmp_s2);
            if (!cmd)
                goto _cmd_err;
            if (cmd[0] == 'q' || cmd[0] == 'Q')
                return 0;
            paddr = strtok_r(NULL, delim2, &tmp_s2);
            if (!paddr)
                goto _cmd_err;
            addr = strtoul(paddr, &endptr, 16);
            if (*endptr)
                goto _cmd_err;
            fn = NULL;
            if (strncmp(cmd, "mw", 3) == 0)
            {
                fn = mw;
                pval = strtok_r(NULL, delim2, &tmp_s2);
                if (!pval)
                    goto _cmd_err;
                val = strtoul(pval, &endptr, 16);
                if (*endptr)
                    goto _cmd_err;
                len = 1;
            }
            else if (strncmp(cmd, "md", 3) == 0)
            {
                fn = md;
                len = 0x40;
                val = 0;
            }
            else
            {
                goto _cmd_err;
            }
            plen = strtok_r(NULL, delim2, &tmp_s2);
            if (plen)
            {
                len = strtoul(plen, &endptr, 16);
                if (*endptr)
                    goto _cmd_err;
            }

            if (fn)
                fn(addr, val, len);

            command = strtok_r(NULL, delim1, &tmp_s1);
        }
_command_loop:
        if (!quiet)
            fputs("> ", stderr);
        continue;
_cmd_err:
        fprintf(stderr, "md addr [len]\nmw addr val [len]\n"
                        "q[uit] | ctrl-d | ctrl-c to exit\n");
        if (!quiet)
            fputs("> ", stderr);
    }
    return 0;
}

typedef enum
{
    CPU_NONE = 0,
    CPU_PILOT3,
    CPU_PILOT4,
    CPU_AST2500,
    CPU_AST2600,
    CPU_MAX,
} CPU_TYPE;

static CPU_TYPE probe_cpu(void)
{
    FILE *f;
    char cpuinfo[128];
    static CPU_TYPE this_cpu = CPU_NONE;

    if (CPU_NONE == this_cpu)
    {
        f = fopen("/sys/firmware/devicetree/base/compatible", "r");
        if (f) {
            int br = fread(cpuinfo, 1, sizeof(cpuinfo)-1, f);
            if (br > 0) {
                cpuinfo[br] = 0;
                char *v = cpuinfo;
                while (v < (cpuinfo + sizeof(cpuinfo)) && *v) {
                    if (strncmp("aspeed,ast2500", v, 15) == 0)
                    {
                        if (!quiet)
                            fprintf(stderr, "AST2500\n");
                        this_cpu = CPU_AST2500;
                    }
                    v += 1 + strnlen(v, sizeof(cpuinfo) - (v - cpuinfo));
                }
            }
            fclose(f);
        }
    }
    if (CPU_NONE == this_cpu)
    {
        const char delim[] = "\r\n\t :";
        char *tmp_s;
        f = fopen("/proc/cpuinfo", "r");
        if (f != NULL) {
        while (fgets(cpuinfo, sizeof(cpuinfo), f))
        {
            strtok_r(cpuinfo, delim, &tmp_s);
            if (strncmp("Hardware", cpuinfo, 9) == 0)
            {
                char *v = strtok_r(NULL, delim, &tmp_s);
                if (v)
                {
                    if (strncmp("AST2500", v, 8) == 0)
                    {
                        if (!quiet)
                            fprintf(stderr, "AST2500\n");
                        this_cpu = CPU_AST2500;
                        break;
                    }
                    else if (strncmp("ASpeed SoC", v, 11) == 0)
                    {
                        if (!quiet)
                            fprintf(stderr, "Found ASpeed SoC\n");
                        this_cpu = CPU_AST2500;
                        break;
                    }
                    else if (strncmp("ServerEngines PILOT3", v, 21) == 0)
                    {
                        if (!quiet)
                            fprintf(stderr, "Found PILOT3\n");
                        this_cpu = CPU_PILOT3;
                        break;
                    }
                }
            }
            else if (strncmp("CPU", cpuinfo, 4) == 0)
            {
                char *v = strtok_r(NULL, delim, &tmp_s);
                if (!v || strncmp("part", v, 5) != 0)
                {
                    continue;
                }
                v = strtok_r(NULL, delim, &tmp_s);
                if (v)
                {
                    if (strncmp("0xb76", v, 6) == 0)
                    {
                        if (!quiet)
                            fprintf(stderr, "AST2500\n");
                        this_cpu = CPU_AST2500;
                        break;
                    }
                    else if (strncmp("0xc07", v, 6) == 0)
                    {
                        if (!quiet)
                            fprintf(stderr, "AST2600\n");
                        this_cpu = CPU_AST2600;
                        break;
                    }
                }
            }
        }
        fclose(f);
        }
    }
    return this_cpu;
}

static const char *probe_cpu_for_map(void)
{
    switch (probe_cpu())
    {
    case CPU_PILOT3:
        return "0:2000000,10000000:8000,40000000:43b000";
    case CPU_AST2500:
        return "0:4000000,1e600000:1a0000,20000000:4000000";
    case CPU_AST2600:
        return "0:20000000,38000000:8000000,60000000:20000000";
    default:
        return "";
    }
}

static void usage(void)
{
    fprintf(stderr,
        "Usage: io [-c config] [-m map]\n"
        "       md [-c config] [-m map] <addr> [len]\n"
        "       mw [-c config] [-m map] <addr> <val> [len]\n\n"
        "With:      -c config    load mappings from file config\n"
        "           -m map       load mappings from string map\n"
        "           addr, val, len are all hex numbers\n\n"
        "When invoked as io, this will start a shell that will\n"
        "allow the user to type in md and mw commands much like\n"
        "the U-Boot environment. By default, it will map in all\n"
        "the addresses for the known processor type.\n\n"
        "map string is of the format addr:len[,addr2:len2...]\n"
        "config file is of the same format as map string\n"
        "but with each mapping on separate lines instead of\n"
        "comma separated values\n"
    );
    exit(1);
}

#define shift if (++i >= argc) usage()

int main(int argc, const char *argv[])
{
    char *exe_full;
    char *exe;
    char *endptr;
    int i, first_arg = 1;
    const char *cfg_file = NULL;
    const char *map_str = NULL;
    size_t flen = 0;
    size_t len = 0;
    unsigned long addr;
    uint32_t val;
    int ret = 0;

    i = 1;
    while (i < argc)
    {
        if (argv[i][0] == '-')
        {
            switch (argv[i][1])
            {
            case 'm':
                shift;
                map_str = argv[i];
                break;
            case 'c':
                shift;
                cfg_file = argv[i];
                break;
            default:
                usage();
            }
        }
        else
        {
            first_arg = i;
            break;
        }
    }

    exe_full = strdup(argv[0]);
    if (exe_full != NULL )
        exe = basename(exe_full);
    else
        return ret;

    if (strncmp(exe, "io", 3) != 0 || !isatty(fileno(stdin)))
        quiet = 1;

    if (!map_str)
    {
        if (!cfg_file)
            map_str = probe_cpu_for_map();
        else
            map_str = map_file(cfg_file, &flen, PROT_READ, MAP_PRIVATE);
    }
    else
    {
        flen = strlen(map_str);
    }
    if (load_maps(map_str, flen) < 0)
    {
        fprintf(stderr, "failed to map regions: check map string or config file\n");
        goto _cleanup;
    }

    if (strncmp(exe, "md", 3) == 0)
    {
        len = 0x40;
        addr = strtoul(argv[first_arg], &endptr, 16);
        if ((first_arg + 1) < argc)
        {
            len = strtoul(argv[first_arg + 1], &endptr, 16);
        }
        ret = md(addr, 0, len);
        goto _cleanup;
    }

    if (strncmp(exe, "mw", 3) == 0)
    {
        len = 1;
        addr = strtoul(argv[first_arg], &endptr, 16);
        if ((first_arg + 1) < argc)
        {
            val = strtoul(argv[first_arg + 1], &endptr, 16);
        }
        else
        {
            usage();
        }
        if ((first_arg + 2) < argc)
        {
            len = strtoul(argv[first_arg + 2], &endptr, 16);
        }
        ret = mw(addr, val, len);
        goto _cleanup;
    }

    io();

_cleanup:
    unmap_all();
    free(exe_full);
    return ret;
}
