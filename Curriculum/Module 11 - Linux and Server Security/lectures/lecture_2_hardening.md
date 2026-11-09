# Linux Hardening

## Why is Linux Server Hardening Important?

Anyone who runs computer infrastructure they rely upon should be concerned about hardening their systems. This is especially important where user data such as Personally Identifiable Information are involved.

There are different kinds of system hardening:

- Server hardening
- OS Hardening
- Application hardening

Each kind covers one layer of the stack, and a layer is only a secure base for
the one above it if it has been hardened itself. An attacker needs one
unhardened layer; the defender needs all of them:

```text
  +----------------------------------------------------+
  | Application  TLS, least privilege, patched         |  Application
  |              dependencies, logs shipped off-host   |  hardening
  +----------------------------------------------------+
  | OS / Kernel  SELinux or AppArmor, sysctl, ASLR,    |  OS
  |              file permissions, fewer services      |  hardening
  +----------------------------------------------------+
  | Bootloader   GRUB config owned by root,            |
  |              SecureBoot verifies the kernel        |  Server
  +----------------------------------------------------+  hardening
  | Hardware     BIOS password and updates, USB        |
  |              disabled, full disk encryption        |
  +----------------------------------------------------+

  Compromising a lower layer defeats every layer above it.
```

## Server hardening

Each layer and component of a system needs to be hardened to ensure that they provide a secure base for the next layer. This all starts with the hardware, the foundation of the application stack.

The idea is to make the server as robust as possible against local attacks, i.e. people with physical access to the machine, and prevent them from snooping on the data on the server or introducing malicious code.

### BIOS updates

Manufacturers frequently release new BIOS versions to address security issues, and it's important to keep on top of these by updating to the latest version as soon as is reasonable.

### SecureBoot

This uses digital signatures to ensure that the system boots genuine signed code, and means that it is harder for an attacker with physical access to the server to subvert the boot process.

### Set BIOS passwords

 Features such as SecureBoot can be disabled in the BIOS, so it's important to set a BIOS password to prevent that.

### Disable USB ports

If the server doesn't need to use certain hardware features, these can often be disabled in the BIOS, to further prevent physical attacks against the system.

### Full disk encryption

Disk encryption means that someone can't take the disks out of the machine and access or modify the contents offline. In cloud environments and virtual machines, disk encryption also prevents a malicious actor at the hypervisor level from accessing ones virtual disks.

## OS Hardening

The following topics aim to enhance the security of a server by implementing a series of measures aimed at reducing vulnerabilities and minimizing potential attack surfaces on an OS level:

### Bootloader (Grub)

To ensure that a user cannot change the kernel or distribution, it is recommended to change access to the bootloader config files. To completely thwart a boot into another OS on the computer, the bios should have a admin password set.

Steps for root for grub:

1. Set the owner and group of `/etc/grub.conf` and `/etc/grub.d` or in some cases `/etc/default/grub`.

    ```bash
    chown root:root /etc/grub.conf
    chown -R root:root /etc/grub.d
    chown root:root /etc/default/grub
    ```

2. Set permissions for `/etc/grub.conf` and `/etc/grub.d` or in some cases `/etc/default/grub`

    ```bash
    chmod og-rwx /etc/grub.conf
    chmod -R og-rwx /etc/grub.d
    chmod og-rwx /etc/default/grub
    ```

### Linux Kernel

The heart of a linux distribution is the kernel, protecting it is absolutely necessary to ensure a hardened server. What now follows are configs to protect kernel logs and logs, the memory and enable ExecShield to protect the system from certain buffer overflow vulnerability and arbitrary code execution.

#### Kernel logs

Kernel logs are an important part of machine administration. Logs can reveal information about the state of daemons, show warnings or other critical messages. The logs are split into eight log levels, starting at level 0 and decreasing in severity until level 7, which are debug logs. In order to protect these logs from unauthorized access, one can restrict the permissions of the logs with the following command:

Steps for root:

1. Restrict access to the kernel logs in the sysctl.d config files

    ```bash
    echo "kernel.dmesg_restrict = 1" > /etc/sysctl.d/50-dmesg-restrict.conf
    ```

#### Kernel pointer

Several `/proc` and `/sys` interfaces print kernel memory addresses, which is exactly the information an exploit needs in order to aim at kernel structures. With `kernel.kptr_restrict = 1`, those addresses are printed as zeroes for processes without the `CAP_SYSLOG` capability; a value of `2` hides them from every process, including root.

Steps for root:

1. Restrict access to the kernel pointers in the sysctl.d config files

    ```bash
    echo "kernel.kptr_restrict = 1" > /etc/sysctl.d/50-kptr-restrict.conf
    ```

#### Exec Shield

Exec Shield is a project that has its origins at Red Hat. It was developed in late 2002 with the aim of reducing the risk of worms or other automated remote attacks on Linux systems. It attempts to flag data memory as non-executable and program memory as non-writable, therefore suppressing many security exploits such as buffer overflows or other techniques relying on overwriting data and inserting code.

Exec Shield was a patch for Red Hat kernels and was never merged into the mainline kernel, so the `kernel.exec-shield` setting below exists only on older Red Hat based systems. On a current kernel the same protection comes from the hardware NX bit, which the kernel enables on its own, and there is nothing to configure; `sysctl` on such a system rejects the key as unknown. It is shown here because it is still found in many older hardening guides.

Steps for root (older Red Hat based systems only):

1. Enable Exec Shield in the sysctl.d config files

    ```bash
    echo "kernel.exec-shield = 2" > /etc/sysctl.d/50-exec-shield.conf
    ```

#### Memory protection

The Linux kernel has a defense mechanism named address space layout randomization (ASLR), which is tuneable with the `randomize_va_space` setting. The main goal of this patch is to randomize memory segments to make abuse by malicious programs harder.

Steps for root:

1. Enable memory randomization in the sysctl.d config files

    ```bash
    echo "kernel.randomize_va_space=2" > /etc/sysctl.d/50-rand-va-space.conf
    ```

### Config SELinux

SELinux stands for Security-Enhanced Linux and is a kernel security module that confines what each process may do, independently of file permissions. On Red Hat based distributions it is shipped enabled, but on some systems it runs in permissive mode, where violations are only logged instead of blocked. Debian and Ubuntu ship AppArmor instead, which solves the same problem with profiles per program; on those systems the file below does not exist and `aa-status` is the equivalent check.

Steps as root:

1. Change the mode in `/etc/selinux/config` (`SELINUX` sets the mode, `SELINUXTYPE` selects the policy and stays as it is, usually `targeted`)
 `SELINUX=enforcing`
2. Remove this line from `/etc/default/grub` if it exists
 `selinux=0`

### Network

To protect from potential risks in the network layer there are several settings to enhance the security of the system, like enabling TCP SYN Cookie protection, disabling IP source routing and ignoring broadcast requests.

All of the following settings are written into the same file, so note the
difference between `>`, which creates or truncates the file, and `>>`, which
appends a line. Using `>` for every step would leave only the last setting in
place. After editing, apply the file with `sysctl --system`.

#### TCP/SYN Cookie protection

The TCP SYN Cookie protection setting in Linux is a precaution against TCP SYN flood attacks that can cause a denial of service by overloading the system's TCP connection table. Using SYN cookies prevents connection from being tracked until an ACK is received.

Steps as root:

1. Enable TCP SYN Cookie protection

    ```bash
    echo "net.ipv4.tcp_syncookies = 1" > /etc/sysctl.d/50-net-stack.conf
    ```

#### Routing

Source routing is a IP mechanism that allows IP packets to carry a list of addresses that tells a router the path the packet must take. This allows the "source" to specify the route, ignoring the routing tables of other routers. It can allow a user to redirect network traffic for malicious purposes.

Steps as root:

1. Disable IP source routing

    ```bash
    echo "net.ipv4.conf.all.accept_source_route = 0" \
      >> /etc/sysctl.d/50-net-stack.conf
    ```

#### ICMP

Two separate things are configured here. Refusing ICMP redirects stops another
host on the network from rewriting the local routing table, which is a real
attack. Ignoring ICMP echo requests ("ping") only makes the host slightly less
obvious to untargeted scans; a port scan still finds it, so treat this as noise
reduction rather than protection, and remember that it also makes network
troubleshooting considerably harder.

Steps as root:

1. Disable ICMP redirect acceptance

    ```bash
    echo "net.ipv4.conf.all.accept_redirects = 0" \
      >> /etc/sysctl.d/50-net-stack.conf
    ```

2. Enable ignoring ICMP echo requests

    ```bash
    echo "net.ipv4.icmp_echo_ignore_all = 1" \
      >> /etc/sysctl.d/50-net-stack.conf
    ```

#### Broadcast

This setting deals with the IPv4 ICMP echo broadcasts. There messages are the messages used by the "ping" tool. By ignoring broadcast ICMP echo requests the machine won't respond when someone tried to ping a broadcast address to find all hosts on the network.

Steps as root:

1. Enable ignoring broadcast requests

    ```bash
    echo "net.ipv4.icmp_echo_ignore_broadcasts = 1" \
      >> /etc/sysctl.d/50-net-stack.conf
    ```

## Application hardening

When it comes to application security, it is more difficult to be prescriptive about hardening as each application has its own security requirements. However, there are general security and hardening principles that can be applied to most applications:

### Enforce strong encryption

For example, web-based applications use TLS, for which certificates can be provisioned through Let's Encrypt.

### Principle of Least Privilege

For the best security practices, system privileges should only be granted to those who require them. A minimum access policy ensures that users have the lowest level of privileges to complete necessary functions.

### Configure logging, and monitor logs for anomalies

Application logs should be aggregated remotely to ensure that they can't be altered or destroyed by an attacker, and the logs should be analysed to detect anomalous behaviour which could reveal the start of an active attack.

### Check dependencies for vulnerabilities

Most applications have a large number of software libraries and dependencies, any of which might have security vulnerabilities. All components need to be kept patched and up to date.

## Resources

- <https://www.cyberciti.biz/tips/linux-security.html>
- <https://www.netwrix.com/linux_hardening_security_best_practices.html>
- <https://linuxsecurity.expert/checklists/linux-security-and-system-hardening>
- <https://ubuntu.com/blog/what-is-system-hardening-definition-and-best-practices>
