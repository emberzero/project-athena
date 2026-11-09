#import "../../../typst-theme-emberzero/1.1.0/src/lib.typ": *

#show: athena-theme.with(
  font: "Berkeley Mono",
  config-info(
    title: [Module 11: Linux and Server Security],
    subtitle: [Linux Basics],
    authors: [*Marcel Schnideritsch*],
    extra: [],
    footer: [Module 11 - Linux and Server Security],
  ),
  config-common(
    handout: false,
  ),
)

#title-slide()

#section-slide(title: "What is Linux?")

#slide(title: "Linux is \"only\" a Kernel")[
  #color-block(title: [Kernel])[
    Manages resources, abstracts hardware, exposes a well-defined syscall API.
  ]

  - Cannot do much on its own, needs userspace programs (usually GNU)
  - *Distribution* = kernel + userspace + UI + default apps + config
  - A distro is roughly what "Windows" is as a whole
  - Linux is *unixoid*: behaves like UNIX, shares no code with it
]

#slide(title: "Some History")[
  - *1960s*: one job at a time on huge machines, everyone else waits
  - *MULTICS* (MIT, Bell Labs): time-sharing. Died off.
  - *Ken Thompson* strips MULTICS down, rewrites it in assembler: *UNIX*
  - *Dennis Ritchie* joins. Porting in assembler hurts, so they invent *C* and rewrite UNIX in it
  - Bell Labs licenses UNIX to universities. Berkeley improves it: *BSD* vs. *System V*
  - The two diverge massively. IEEE steps in: *POSIX*. C gets standardised by ANSI/ISO.

  #text(size: 0.7em)[Tanenbaum, Modern Operating Systems, 4th ed., p. 714ff]
]

#slide(title: "POSIX")[
  #color-block(title: [Portable Operating System Interface])[
    Standardises the interface between a system and its applications.
  ]

  - Syscalls
  - Essential programs, most notably the *shell*
  - Current revision: 2017
  - Linux behaves like UNIX but is not fully POSIX-compliant
]

#section-slide(title: "Filesystem Hierarchy")

#slide(title: "FHS")[
  Almost every distro follows the *Filesystem Hierarchy Standard*.

  ```bash
  $ ls /
  bin  boot  dev  etc  home  lib  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
  ```

  What is all this, and where is my data?

  #text(size: 0.7em)[https://refspecs.linuxfoundation.org/FHS_3.0/fhs-3.0.pdf]
]

#slide(title: "Essentials: /bin, /sbin, /lib")[
  - `/bin`: binaries needed to get the system running (shell, mount, fsck, ...)
  - `/sbin`: system administration binaries, run as root
  - `/lib`: shared libraries and kernel modules needed by `/bin` and `/sbin`
  - `/dev`: device files. *Everything is a file.*

  ```bash
  $ ls -l /dev/sda /dev/null
  brw-rw---- 1 root disk 8, 0 /dev/sda
  crw-rw-rw- 1 root root 1, 3 /dev/null
  ```
]

#slide(title: "Configuration: /etc")[
  All system-wide configuration lives here.

  - `/etc/passwd`: user accounts
  - `/etc/shadow`: password hashes and salts
  - package manager, kernel modules, services, audio, ...

  #color-block(title: [For attackers and defenders])[
    `/etc` is the first place to look for misconfigurations and credentials.
  ]
]

#slide(title: "Users: /root and /home")[
  - `/root`: home directory of root
  - `/home/<user>`: home directory of every other user, referenced as `~`
  - Contents are not defined by the FHS, but usually:
    - `Desktop`, `Documents`, `Pictures`, ...
    - `.config` for per-user configuration
    - `.ssh` for keys
]

#slide(title: "The Big One: /usr")[
  "Shareable, read-only data": the bulk of the installed system.

  #split(
    [
      - `/usr/bin`: user commands
      - `/usr/sbin`: admin commands
      - `/usr/lib`: libraries
      - `/usr/include`: C headers
    ],
    [
      - `/usr/share`: fonts, images, docs
      - `/usr/libexec`: helpers run by other programs
      - `/usr/src`: source code
      - `/usr/local`: same layout, for software installed *outside* the package manager
    ],
  )
]

#slide(title: "The Rest")[
  - `/tmp`: temporary files, often in RAM, cleared on reboot
  - `/var`: variable data such as logs, caches, mail
  - `/run`: runtime state since boot (PID files, sockets)
  - `/srv`: data served by this host
  - `/opt`: self-contained third-party software
  - `/mnt`: temporary mount points
  - `/boot`: kernel and bootloader
]

#section-slide(title: "Software and Desktops")

#slide(title: "Package Management")[
  Software is installed via the distro's *package manager* (`apt`, `dnf`, `zypper`, `pacman`).
  It tracks versions, dependencies and file conflicts.

  Sometimes bypassed:
  - Ancient versions in non-rolling distros
  - Proprietary vendor installers
  - Language ecosystems with their own tooling (`pip`, `npm`, `cargo`)

  #color-block(title: [Cost])[
    No auto-updates, unresolved conflicts, messy removal. Prefer the package manager.
  ]
]

#slide(title: "User Interfaces")[
  *Desktop Environments*: the full experience
  - *KDE*: customisable, feature-rich, Windows-like
  - *GNOME*: polished, Mac-like, few knobs
  - *XFCE, LXDE*: lightweight, good for old hardware

  *Window Managers*: only draw and arrange windows, you build the rest
  - i3/sway, Hyprland, QTile, bspwm, dwm, xmonad
]

#slide(title: "Trying It Out")[
  - *Live USB / CD*: zero commitment, loses state on reboot
  - *Virtual machine*: snapshots and backups for free
  - *Install on USB stick*: portable, possibly slow
  - *Second disk*: external SSD or spare internal drive
  - *Dual boot*: pick Windows or Linux at startup

  Ease in slowly and customise as you go.
]

#section-slide(title: "The Shell")

#slide(title: "Why Bother?")[
  - Essential for CTFs and system administration
  - You can do almost anything
  - Often faster than clicking through a GUI
  - Scriptable: do it once, run it forever
  - Plenty of beautiful TUI applications
]

#slide(title: "Do Not Fear the Shell")[
  #split(
    [
      *Reassuring*
      - Real damage needs root. Use it sparingly.
      - Dangerous commands have safeguards
    ],
    [
      *Still*
      - Respect the power
      - *Never paste a command you do not understand*
    ],
  )

  Open a terminal emulator: GNOME Terminal, Konsole, xterm, alacritty, kitty, wezterm, ...
]

#slide(title: "Common Commands")[
  - *Printing*: `echo`, `printf`
  - *Filesystem*: `cd`, `ls`, `cat`, `mkdir`, `touch`, `rm`, `cp`, `mv`
  - *Data*: `grep`, `sort`, `uniq`, `wc`, `sed`, `cut`
  - *Paging*: `less`

  ```bash
  man ls          # the manual
  ls --help       # quick reference
  apropos "list"  # find a command by keyword
  ```

  There most certainly is a command for your need.
]

#slide(title: "Piping")[
  Normally stdin and stdout are connected to the terminal.
  A pipe `|` connects one program's stdout to the next one's stdin.

  ```bash
  cat test.txt | sort -n | head -n 1
  ```

  1. Output the file
  2. Sort it numerically
  3. Keep the first line

  Result: the smallest number in the file.
]

#slide(title: "Redirections")[
  ```bash
  program  >file        # overwrite file with stdout
  program >>file        # append stdout to file
  program  <file        # read stdin from file
  program 2>/dev/null   # discard stderr (fd 2)
  program 2>&1          # merge stderr into stdout
  ```

  ```bash
  cat <gift.png >gift_copy.png   # cp without cp
  date >>date.list               # keep a log of dates
  ```

  #color-block(title: [Careful])[
    `>` destroys existing content without asking.
  ]
]

#slide(title: "Variables")[
  ```bash
  NAME="Hans Herbert"       # no spaces around '='
  echo "Hello ${NAME}"      # Hello Hans Herbert
  LIST_DIR="ls"
  ${LIST_DIR}               # runs ls
  ```

  - `$VAR` or `${VAR}`: the braces are cleaner, compare `"$nth"` and `"${n}th"`
  - A literal `$` needs `\$` or single quotes
  - `set` lists all variables. There are many.
]

#slide(title: "Shell vs. Environment Variables")[
  - Shell variables are *invisible* to the programs you start
  - Environment variables are inherited by child processes

  ```bash
  export VAR=value   # set and export
  export VAR         # export an existing shell variable
  export             # list all environment variables
  ```
]

#slide(title: "Command Substitution")[
  Run a command in a subshell and use its output as a string.

  ```bash
  TODAY=$(date +%F)
  echo "Backup from ${TODAY}"
  FILES=$(ls | wc -l)
  ```
]

#slide(title: "Exit Codes")[
  Every program returns a number. `0` is success, everything else failure.

  - `126`: file found but not executable
  - `127`: command not found
  - `>128`: killed by a signal

  ```bash
  grep root /etc/passwd
  echo $?    # 0 if found, 1 if not
  ```

  #color-block(title: [Caution])[
    `$?` is overwritten by *every* command, including `echo` and `if`. Save it if you need it later.
  ]
]

#slide(title: "Process Substitution")[
  Make a command's output look like a file.

  ```bash
  diff -u <(ls) <(ls -a)   # what do hidden files add?
  ```

  - `<(cmd)` is replaced by a path the receiving program can read
  - `>(cmd)` works the other way round
]

#slide(title: "Arithmetic")[
  Integer arithmetic is built in via `$(( ))`. No `${}` needed inside.

  ```bash
  VALUE1=39
  VALUE2=3
  echo "$((VALUE1 + VALUE2))"             # 42
  echo "32 bits have $((2**32)) states"
  ```

  No floating point. Use `bc`:

  ```bash
  echo "${VALUE1} / ${VALUE2}" | bc -l    # 13.0000...
  ```
]

#section-slide(title: "Shell Scripts")

#slide(title: "Scripts")[
  Save commands in a file and run it: `bash script.sh`

  To run it directly as `./script.sh`:
  1. Make it executable: `chmod +x script.sh`
  2. First line is a *shebang* pointing to the interpreter

  ```bash
  #!/usr/bin/bash
  echo "Hello $@"
  ```

  Works for anything: `#!/usr/bin/env python3`
]

#slide(title: "Arguments")[
  - `$#`: number of arguments
  - `$1`, `$2`, `$3`, ...: the individual arguments
  - `$@`: all arguments, handy for passing them on
  - `exit [code]`: return an exit code, defaults to the last command's

  ```bash
  #!/usr/bin/bash
  echo "$1 / $2 = $(echo "$1 / $2" | bc -l)"
  ```
]

#slide(title: "Control Flow: if")[
  `then` must be on a new line or after a `;`

  ```bash
  if [ -f /etc/passwd ]; then
      echo "found"
  elif [ -d /home ]; then
      echo "at least /home exists"
  else
      echo "strange system"
  fi
  ```
]

#slide(title: "Comparisons with [")[
  `[` is a command (also called `test`), so it needs spaces and a closing `]`.

  #split(
    [
      - `[ -n "s" ]`, `[ -z "" ]`: string length
      - `[ "a" = "a" ]`, `[ "a" != "b" ]`
      - `[ 1 -eq 1 ]`, `[ 1 -ne 2 ]`
      - `[ 3 -gt 2 ]`, `[ 2 -lt 3 ]`, `[ 3 -ge 3 ]`
    ],
    [
      - `[ -f file ]`, `[ -d dir ]`: exists
      - `[ ! expr ]`: negation
      - `-a`, `-o`: and, or
      - `true`, `false`
      - Any program's exit code works
    ],
  )
]

#slide(title: "Control Flow: Loops")[
  ```bash
  for i in $(seq 1 5); do
      echo "2^${i} = $((2**i))"
  done

  while [ "${n}" -lt 10 ]; do
      n=$((n + 1))
  done
  ```

  - `for` iterates a whitespace-separated list (change with `IFS`)
  - `seq <start> <end> [step]` gives a counter
]

#slide(title: "Example: Guessing Game")[
  ```bash
  NUMBER=$((RANDOM % 100))
  while true; do
      echo "Enter a number:"
      read GUESS
      if [ "${GUESS}" -gt "${NUMBER}" ]; then
          echo "Overshot"
      elif [ "${GUESS}" -lt "${NUMBER}" ]; then
          echo "Undershot"
      else
          echo "CORRECT!"
          break
      fi
  done
  ```
]

#slide(title: "Functions")[
  ```bash
  progress() {
      PERCENT="$1"; SIZE="$2"
      FILL=$(((SIZE * PERCENT) / 100))
      printf "["
      for _ in $(seq 1 ${FILL}); do printf "="; done
      for _ in $(seq 1 $((SIZE - FILL))); do printf " "; done
      printf "]\n"
  }
  progress 40 20    # [========            ]
  ```

  - Arguments work like in scripts: `$#`, `$@`, `$1`, ...
  - Use `return [n]`, not `exit`. `exit` kills the whole shell.
]

#slide(title: "Herestrings and Heredocs")[
  Feed fixed text into stdin without `echo |`.

  ```bash
  grep root <<< "root:x:0:0"    # herestring

  cat <<EOF                     # heredoc
  line one
  line two
  EOF
  ```

  Great for automating interactive programs. `EOF` can be any word.
]

#slide(title: "Many More Features")[
  - Background processes: `command &`
  - `${#VAR}`: length of a variable
  - `${VAR:-default}`: fallback value
  - `${VAR#prefix}`, `${VAR%suffix}`: strip text
  - `case ... esac`
  - Arrays (shell-dependent)
  - `!!`: repeat the last command

  Read the manual: `man sh`, `man bash`, `man zshall`
]

#section-slide(title: "Which Distro?")

#slide(title: "What Actually Differs")[
  Most distros are similar. They differ in:

  - *Package manager*: apt, dnf, zypper, pacman
  - *Preinstalled packages* and *default configuration*
  - *Version stability*: how fast new features land
  - *Governance*: company or community? Who gets to be a maintainer?

  #text(size: 0.7em)[Family tree: https://distrowatch.com/dwres.php?resource=family-tree]
]

#slide(title: "Specialised Distros")[
  Preconfigured for one job, best run from a live USB:

  - *Kali Linux, BlackArch*: penetration testing
  - *Tails*: amnesic, routes everything through Tor
  - *GParted, Clonezilla*: disk tools that only work offline

  Not meant for permanent installation.
]

#slide(title: "Just Give Me a Working System")[
  *Fedora, Debian, Pop!\_OS, openSUSE Leap, (Ubuntu), (Linux Mint)*

  - Sane defaults, good set of standard programs
  - Older versions in the repos, Flatpak and Snap fill the gaps
  - Older kernel may lack support for brand-new hardware
  - Version upgrades are rare and painful on Ubuntu-based distros
]

#slide(title: "I Want the Latest Stuff")[
  *endeavourOS, openSUSE Tumbleweed*

  - *Rolling release*: new versions land within days
  - No big version upgrades, ever
  - New features bring new bugs
  - Usually staged through a testing channel first, but expect occasional troubleshooting
]

#slide(title: "I Want Full Control")[
  *Arch Linux*

  - Rolling release, same trade-offs
  - You install and configure every package yourself
  - Nothing on the system you did not ask for
  - First install takes a while, but you learn how it all fits together
  - *AUR*: community build scripts for nearly everything. *Read them before running.*
]

#slide(title: "I Have No Other Obligations")[
  #split(
    [
      *NixOS*
      - Declare the whole system in a functional language
      - Reproducible, version-controlled, snapshots
      - Multiple package versions side by side
      - Ignores the FHS, programs get patched
    ],
    [
      *Gentoo*
      - Everything built from source
      - Binaries tuned for your exact CPU
      - Rolling release
      - Bring time and coffee
    ],
  )
]

#standout-slide(title: [Thank you for your attention!])
