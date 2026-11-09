# Assignment 1: Assessing a Deliberately Vulnerable Android App

## Objective

You will carry out a full assessment of one deliberately vulnerable Android app on your own
emulator: unpack and decompile it, enumerate what it exposes to other apps, look at what it writes
to storage, confirm one finding at runtime with a Frida hook, and rebuild and re-sign it with your
own key. You will report the findings the way MASVS and MASTG expect them, with impact and a fix
rather than a list of observations.

## Logistics

- **Work:** individual, or in pairs. Pairs hand in one report naming both authors; the keystore
  fingerprint and hook output must be from one named partner's own machine, and the other partner
  contributes a second, separate finding.
- **Deadline:** *set by your instructor*.
- **Submission:** one PDF, named `Lastname_Firstname_Module18_Assignment1.pdf`.

## Setup

Everything here is free. Nothing is bought and nothing is rooted that you do not own.

- **Android Studio**, for the SDK platform tools (`adb`), the build tools (`zipalign`,
  `apksigner`) and the emulator. Create an AVD with a system image **without Google Play**, so
  that `adb root` gives you a root shell.
- **apktool** and **jadx**, both free and both available as a single archive or via a package
  manager.
- **Frida** and optionally **Objection**, installed on the host with `pip`, plus the matching
  `frida-server` binary for your emulator's architecture.
- **MobSF** is optional. If you use it, run it as a container as shown in Lecture 5 and treat its
  output as a lead list, not as findings.
- **The target app:** one deliberately vulnerable practice app of the kind listed in Lecture 1 -
  an OWASP MASTG crackme, or a training app such as InsecureBankv2 or DIVA - or an APK your
  instructor hands out. Confirm your choice with your instructor before you start, and state in
  the report which app and which version you used.

**Hardware note.** The Android emulator needs hardware virtualisation and roughly 8 GB of RAM to
be comfortable. If your machine cannot run it, you have two no-cost alternatives: an old Android
phone you own personally, with developer options and USB debugging enabled, or a static-only route
in which your instructor supplies both the APK and a pre-recorded `adb`/Frida session. Say in the
report which route you took. Tasks 1, 2, 3 and 6 need no device at all.

## Rules of engagement

- The only app you analyse is the practice app. The only device you touch is your own emulator or
  a phone that belongs to you personally.
- Not in scope, under any circumstances: an app from the Play Store that is not a practice app, a
  classmate's phone, a school-owned or employer-owned device, the school network, or any backend
  that is not the practice app's own bundled one. Do not proxy, scan or send traffic to a real
  production API.
- Anything you pull off a device is personal data under the GDPR even in a lab. Keep it in your
  working directory, keep it out of the submitted PDF unless it is a lab value, and delete it when
  the assignment is graded.
- Reverse engineering an app without authorisation is not a grey area. See Module 01, and
  StGB §118a, §126a and §126b.

## Tasks

### 1. Open the package

Run `unzip -l` on the APK and describe its structure: the manifest, `classes*.dex`, resources,
assets, and whether it ships native libraries under `lib/`. Then decode it:

```bash
unzip -l target.apk
apktool d target.apk -o target-decoded
jadx -d target-src target.apk
```

**Deliverable:** the structure description, the APK's SHA-256 hash, the package name, and the
`minSdkVersion` and `targetSdkVersion` from the decoded manifest. Note whether native code is
present and, if it is, what `readelf --dyn-syms` shows for one library.

### 2. Enumerate the exported surface

From the decoded `AndroidManifest.xml`, list every activity, service, receiver and provider that is
reachable by another app, and say for each one why: an explicit `android:exported="true"`, an
intent filter, or a missing permission. Also record `android:debuggable`,
`android:allowBackup` and whether a network security config is referenced.

**Deliverable:** a table of exported components with the reason each is exposed, plus the three
manifest flags and what each one means for an attacker with a co-installed app or a backup.

### 3. Read the code

Using `jadx-gui` and `grep` across the decompiled source, find and quote the code for at least
three of the following, each in a different MASVS category:

- a hardcoded key, token or URL that should not be in a shipped binary
- a weak cryptographic construction: ECB mode, a fixed or zero IV, a fast hash used for a
  password, or a key derived from something predictable
- TLS validation weakened in code, for example a custom `TrustManager` or `HostnameVerifier`
- a security decision made locally that the server should be making
- a credential or token written to `logcat`

**Deliverable:** for each finding, the class and method, the quoted lines, the MASVS category, and
one sentence stating what an attacker gains. A line of code with no stated consequence scores zero.

### 4. Probe the app at runtime

Install the app on your emulator and exercise it normally for a few minutes. Then:

```bash
adb shell dumpsys package <package> | less
adb shell am start -n <package>/.SomeActivity
adb shell content query --uri content://<package>.provider/<path>
adb shell run-as <package> ls -la /data/data/<package>
adb logcat | grep -i -E 'token|password|authorization'
```

Reach at least one exported component directly from the shell, and inspect what the app wrote to
storage after you used it.

**Deliverable:** the commands and their output for one component reached from the shell, one
sensitive item recovered from storage or `logcat`, and a sentence on which of the four attackers
from Lecture 1 each of the two findings belongs to.

### 5. Confirm one finding with a hook

Write a Frida hook against one method you identified in Task 3. The hook must **observe**: log the
arguments and the real return value, and return that real value unchanged.

```bash
frida-ps -Ua
frida -U -f <package> -l hook.js
```

**Deliverable:** `hook.js`, the logged output, and two sentences comparing what the hook showed
with what you predicted from the decompiled code. If they disagree, explain why - that is the
interesting result, not a failure.

### 6. Rebuild, re-sign, and draw the conclusion

Rebuild the decoded app, sign it with a keystore you generate yourself, install it, and show the
signing certificate changed:

```bash
keytool -genkey -v -keystore lab.keystore -alias lab -keyalg RSA -validity 10000
apktool b target-decoded -o patched.apk
zipalign -p 4 patched.apk patched-aligned.apk
apksigner sign --ks lab.keystore --out patched-signed.apk patched-aligned.apk
apksigner verify --verbose --print-certs patched-signed.apk
```

**Deliverable:** the SHA-256 certificate fingerprint of the original APK next to the fingerprint of
your own signing key - both must appear, and yours is unique to you. Then answer, in one short
paragraph: given how few commands that took, which of your Task 3 findings cannot be fixed by any
change inside the app, and which server-side control from Lecture 6 fixes it instead.

## Report

Structure it as: introduction naming the app and version, package structure, exported surface
table, code findings, runtime findings, hook result, re-signing evidence, findings table, and a
conclusion. The findings table is the centre of the report:

| ID | Title | MASVS category | Attacker needed | Severity | Evidence | Fix |
| --- | --- | --- | --- | --- | --- | --- |

Severity comes from the attacker you must assume, not from how hard the bug was to find. A remote
attacker outranks one who needs the unlocked phone in hand. Export the report to PDF.

## Evaluation criteria

| Area | Weight | What earns full marks |
| --- | --- | --- |
| Package analysis | 10% | Correct structure description, APK SHA-256, package name and SDK levels, native code addressed. |
| Exported surface | 15% | Every reachable component listed with the correct reason, plus all three manifest flags and their consequences. |
| Code findings | 25% | Three findings in three different MASVS categories, each with class, method, quoted code and a stated attacker gain. |
| Runtime evidence | 15% | One exported component reached from the shell and one sensitive item recovered, both with real command output from the student's own device. |
| Frida hook | 15% | A working observing hook with its log, and an honest comparison against the static prediction. |
| Re-signing and reasoning | 10% | Both certificate fingerprints shown, and the finding that only a server-side control can fix is correctly identified. |
| Findings table and report | 10% | Table complete with defensible severities, clear structure, no observation reported as a finding. |

## Bonus (up to +20%)

Pick one:

- **The backend is the target.** Proxy the practice app's own bundled or local backend, map its
  API, and test one authorisation decision directly against the API with the app out of the
  picture. Show one request that the app's UI would never have sent. Local or bundled backends
  only.
- **Defeat a local check, then explain why it did not matter.** Hook the app's root detection or
  licence check so it returns the convenient answer, demonstrate the app's behaviour changing, and
  then write the attestation design - Play Integrity verified server-side - that would have made
  your hook worthless. Include the hook, the before and after, and the design.
- **iOS static pass.** Take a practice IPA, unzip it, and report the `Info.plist` permission
  purpose strings, the ATS exceptions, the linked frameworks and any hardcoded endpoints. No device
  or jailbreak required. Compare one finding against its Android equivalent from your main report.
