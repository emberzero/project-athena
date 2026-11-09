# Assignment 1: Acquire, Analyse and Report on a Staged Disk Image

## Objective

You will build a small disk image containing a staged incident, hand it to your partner under a
chain of custody, and then forensically examine the image your partner built for you without being
told what is in it. Afterwards you will be able to acquire an image and prove its integrity, recover
and interpret file system artefacts with The Sleuth Kit, build a timeline in UTC, and write findings
that separate observation from interpretation from confidence.

## Logistics

- **Work:** in pairs. Each partner builds one image and examines the other's, and each partner
  submits their own report.
- **Deadline:** *set by your instructor*.
- **Submission:** one PDF per student, named `Lastname_Firstname_Module09_Assignment1.pdf`.
- Submit the image you *built* as well, if your instructor asks for it. Do not submit the image you
  *examined*; your report must stand on its own.

## Setup

Everything runs on a Linux machine or VM you control. No special hardware and no paid tooling.

- A Linux system with root access (Kali, Debian, Ubuntu, or a VM of one of them).
- Packages: `sleuthkit`, `libewf-tools`, `testdisk` (ships `photorec`), `exiftool`, `coreutils`.
  On Debian-based systems: `sudo apt install sleuthkit libewf-tools testdisk libimage-exiftool-perl`.
- Optional: a USB stick you own and do not mind overwriting. A loopback file works for every task in
  this assignment, so the stick is not required.
- Optional: Autopsy, if you prefer a GUI alongside the command-line tools. The report must still
  name the command line or the Autopsy module behind every finding.

## Rules of engagement

- The only evidence you may examine is the image your partner built for you, or an image you built
  yourself.
- Never image, mount or examine a device you do not own: not a school machine, not a shared lab
  machine, not a classmate's laptop, not a found USB stick. Doing so can fall under StGB §118a, and
  a careless write can touch §126a and §126b. Module 01 has the detail.
- Plant nothing in your image that is illegal to possess or distribute, and nothing that identifies
  a real third party. Invented names, invented addresses, your own test files only.
- Keep the image under 256 MB so it is practical to hand over and to grade.

## Task 1: Build the evidence (for your partner)

Create a disk image containing a small staged incident. A loopback file is fine.

```bash
dd if=/dev/zero of=case.img bs=1M count=128
# partition it, create a file system, mount it, populate it, unmount it
```

Requirements for the image you build:

1. A partition table with at least one partition, and at least 1 MB of unpartitioned space
   somewhere on the device.
2. A file system of your choice (ext4, FAT32 or NTFS).
3. At least 12 ordinary files across at least three directories, so the examiner has to separate
   signal from noise.
4. At least one **deleted** file whose content is still recoverable.
5. At least one **file with a misleading extension** (for example a JPEG named `.txt`, or an
   archive named `.log`).
6. At least one file carrying metadata worth finding (an image with EXIF, or a document with
   author/software fields).
7. One short plain-text file containing a token in the form `FLAG{...}`. Choose the token yourself,
   make it unique, and do **not** tell your partner what it is. Place it where it takes work to
   find: inside the deleted file, in the unpartitioned space, or in a file with a misleading name.

Write a **handover note** for your partner containing only: a case identifier, the file name, the
size, the SHA-256 of the image, the date and time in UTC, and your signature. Nothing about the
contents. Keep your own copy of the note and of the token.

**Deliverable in your report:** the handover note you wrote, and a short paragraph stating what you
planted and why you expected each item to be findable. This section proves the image was built to
spec; it is graded separately from your examination of your partner's image.

## Task 2: Acquire and verify

You now hold your partner's image. Treat it as evidence that arrived from outside.

1. Verify the SHA-256 against the handover note. Record both values. If they differ, say so and
   stop to investigate before continuing.
2. Make your working copy with a forensic imager and hash it:

   ```bash
   ewfacquire -t working -f encase6 -d sha256 case.img
   ewfverify working.E01
   ```

3. Explain in one or two sentences why `sha256sum working.E01` does not equal the hash of
   `case.img`, and which hash is the integrity argument.
4. Expose the E01 as a raw device so the analysis tools can read it, and use that path for every
   command in Task 3:

   ```bash
   sudo ewfmount working.E01 /mnt/ewf    # /mnt/ewf/ewf1 is the raw image
   ```

5. Demonstrate that you understand write protection: either use `blockdev --setro` on a loop device
   or a USB stick and show `--getro` returning 1, or mount a file system from the image read-only
   with `-o ro,noload,loop,offset=...` and show that the hash is unchanged afterwards.

**Deliverable in your report:** an acquisition record following the list in Lecture 2, section 2.6,
and a chain-of-custody table with at least three entries covering the handover from your partner to
you. Include both hashes and the result of the comparison.

## Task 3: Examine

Work only on your copy. Every command you run goes into your notes as you run it, not afterwards.

1. **Volume layer.** Run `mmls` and `fsstat`. Report the partition layout, the start sector you used
   as `-o`, the file system type and the block size. Say where the unpartitioned space is.
2. **File system layer.** Run `fls -r -p` for the full listing and `fls -r -d` for deleted entries.
   Recover at least one deleted file with `icat` and show `istat` for its metadata record.
3. **File types.** Run `file` against every recovered and listed file. Identify the file whose
   extension does not match its content and state what it actually is.
4. **Metadata.** Run `exiftool` on the file that carries metadata and quote the fields that would
   matter in an investigation.
5. **Unallocated space and carving.** Extract unallocated blocks with `blkls` and carve them with
   PhotoRec or Foremost. Compare one carved file with one `icat` recovery: which has a name, which
   has a timestamp, which can be tied to a path.
6. **The token.** Find the `FLAG{...}` value and report it verbatim, together with the exact
   commands and the layer it came from. Your partner will confirm whether it is correct.
7. **Timeline.** Build a timeline for the period in which the image was created:

   ```bash
   fls -o <offset> -r -m / /mnt/ewf/ewf1 > body.txt
   mactime -b body.txt -d -z UTC > timeline.csv
   ```

   Extract the 10 to 20 rows that matter into a table in your report. Every row names its source
   artefact and is stated in UTC.

**Deliverable in your report:** a table of every file you identified, with path, type as reported by
`file`, size, MACB times in UTC, and the layer the evidence came from; the recovered token; and the
extracted timeline. Full tool output belongs in an appendix.

## Task 4: Report

Structure the report as in Lecture 4, section 4.2, scaled to this case:

1. Cover and case identification.
2. Scope, and what was out of scope.
3. Executive summary, under one page, answering the four questions from 4.2.1, with no tool names.
4. Evidence inventory, with hashes.
5. Method, with tool names and versions.
6. Findings. Write at least **four** findings in explicit observation / interpretation / confidence
   form. At least one must come out at low or moderate confidence; if all four are high, you are
   overstating.
7. Timeline, in UTC.
8. Limitations. At least four honest entries, specific to this case.
9. Appendices with the raw output.

Then run the peer-review checklist from Lecture 4, section 4.6, against your partner's report and
include a short paragraph on which check caught something. Your partner does the same for yours.

## Evaluation criteria

| Area | Weight | What earns full marks |
| --- | --- | --- |
| **Image built to spec** | 15% | All seven requirements present and findable, plus a handover note with a correct SHA-256 and no leaked hints about the contents. |
| **Acquisition and integrity** | 20% | Both hashes recorded and compared, `ewfverify` output included, the E01-versus-raw hash question answered correctly, write protection demonstrated, and a complete acquisition record and chain-of-custody table. |
| **Examination** | 25% | Correct volume and file system layout, a deleted file recovered with `icat` and `istat`, the misleading extension identified by content, metadata quoted, unallocated space carved and compared with the `icat` recovery, and the correct `FLAG{...}` value with the commands that produced it. |
| **Timeline** | 15% | A consolidated timeline in UTC where every row names its source artefact, with the relevant rows extracted rather than a raw dump pasted in. |
| **Findings and limitations** | 15% | Four or more findings with observation, interpretation and confidence visibly separate, confidence tied to corroboration rather than conviction, and at least four limitations specific to this case. |
| **Report quality** | 10% | Layered structure, an executive summary a non-specialist can read, consistent UTC timestamps, curated appendices, and the completed peer-review paragraph. |
| **Bonus** | +20% | See below. |

## Bonus: anti-forensics and detection

Worth up to +20%. Pick **one** of the two, agree it with your partner first, and label the section
clearly as a bonus.

**Option A: timestamp manipulation.** When you build the image, timestomp one file so that its
recorded times contradict reality. Your partner must then detect the manipulation, say which
artefact exposed it, and explain why the contradiction is visible at all. If you used NTFS, compare
the `$STANDARD_INFORMATION` and `$FILE_NAME` timestamps with `istat`. If you used ext4, use a
redundant source such as the directory entry, the journal, or a second file that must have been
written in the same operation.

**Option B: a hole in the timeline.** When you build the image, wipe the content of one file in
place after the rest of the image is populated, leaving the file system entry intact. Your partner
must locate the hole, show which artefacts prove that something was there, and state honestly what
can and cannot be concluded about what it was.

For either option, the write-up must include the detection method, the artefacts relied on, and a
confidence statement. Full marks require that the detection is argued from the artefacts rather than
from knowing the answer in advance, so do not compare notes until both reports are written.
