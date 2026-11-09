# GTFO Bins

## What is that?

GTFOBins is a catalogue of ordinary Unix binaries that can be abused to do more than they appear to. For a given binary it lists the exact command needed to break out of its intended function, for example to spawn a shell, read or write a file, or transfer data. Combined with a `sudo` entry or a setuid bit on that binary, such a command runs with the binary's elevated privileges, which is what turns it into a privilege escalation.

## How does the website work?

The website greets the user with a searchbar that can be used to search for a binary.
![GTFOBins](images/gtfobins_searchbar.jpg)

Upon clicking on an entry the website shows a list of commands together with the function each one abuses.

The site can also be filtered by function, so that only the binaries offering a chosen capability are displayed. The two filters used most during a privilege escalation are `sudo` and `suid`, because those match what `sudo -l` and a search for setuid binaries have already turned up on the target.

## Resources

- <https://gtfobins.github.io/>
