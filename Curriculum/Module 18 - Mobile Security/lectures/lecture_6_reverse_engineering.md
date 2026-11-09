# Reverse Engineering Mobile Apps

Reverse engineering a mobile app means recovering enough structure from a shipped binary to
understand what it does. You do it to find vulnerabilities, to verify a vendor's claims, to
understand an undocumented API, and, on the defensive side, to analyse a suspected malicious
app.

Everything below runs against a practice app on your own emulator or a device you own. The MASTG
crackmes, InsecureBankv2, DIVA and DVIA exist so that nobody needs to point these tools at
software they have no authorisation to touch.

## What an APK Actually Is

An APK is a ZIP archive with a fixed layout:

```text
  app.apk
    AndroidManifest.xml        binary XML: components, permissions, exports
    classes.dex                Dalvik bytecode (classes2.dex, ... if large)
    resources.arsc             compiled resources
    res/                       layouts, drawables, XML
    lib/arm64-v8a/*.so         native libraries, if any
    assets/                    raw files the developer shipped
    META-INF/                  the signature
```

So the first step needs no special tooling:

```bash
unzip -l app.apk
```

The pieces you want are the manifest, the bytecode, and the native libraries. A `lib/` directory
tells you immediately that part of the logic is in compiled C or C++ and will not appear in any
Java decompilation.

## The Android Toolchain

### apktool: resources and smali

`apktool` decodes the binary manifest and resources into readable form and disassembles the DEX
bytecode into **smali**, a human-readable assembly for the Dalvik/ART instruction set.

```bash
apktool d app.apk -o app-decoded
```

You now have a readable `AndroidManifest.xml` (which is how you enumerate the exported surface
from Lecture 3) plus `res/`, `assets/`, and `smali/` directories mirroring the package structure.

Smali is verbose but it is the ground truth: it is what actually executes. Read it when a
decompiler produces nonsense, and edit it when you want to change behaviour, because apktool can
rebuild:

```bash
apktool b app-decoded -o patched.apk
```

### jadx: readable Java

`jadx` decompiles DEX straight to Java-like source, which is what you read for comprehension.

```bash
jadx -d app-src app.apk
```

There is also `jadx-gui`, which is usually the better way to work: it lets you jump to a class,
follow references, search across the whole app for a string, and switch between the decompiled
Java and the underlying smali for the same method.

Decompilation is lossy. Expect synthetic names, lost generics, odd control flow, and methods the
decompiler gives up on. When the Java looks wrong, read the smali for that method.

### Where to look first

A productive order for an unfamiliar app:

1. **The manifest.** Entry points, exported components, permissions, the `application` class,
   `android:debuggable`, `android:allowBackup`, the network security config reference.
2. **Strings.** URLs, endpoints, keys, feature flags, error messages. `grep` across the decompiled
   source is the highest-value minute you will spend:

   ```bash
   grep -rn -E "https?://|BEGIN (RSA|EC) PRIVATE KEY|Authorization" app-src | head -40
   ```

3. **Crypto and credential use.** Search for `Cipher.getInstance`, `SecretKeySpec`,
   `MessageDigest`, `SharedPreferences`, `Keystore`.
4. **Network layer.** The HTTP client setup and any custom `TrustManager` or `HostnameVerifier`,
   both of which are where TLS validation gets disabled.
5. **Native libraries.** `lib/*.so` plus the `System.loadLibrary` calls that load them, and the
   JNI entry points they expose.

### Re-signing a modified APK

A rebuilt APK has no valid signature and Android will not install it. For lab work, sign it with
a key you generate yourself:

```bash
keytool -genkey -v -keystore lab.keystore -alias lab -keyalg RSA -validity 10000
zipalign -p 4 patched.apk patched-aligned.apk
apksigner sign --ks lab.keystore --out patched-signed.apk patched-aligned.apk
apksigner verify --verbose patched-signed.apk
adb install patched-signed.apk
```

`zipalign` and `apksigner` come from the Android SDK build tools. Note the order: align first,
then sign. Signing after aligning is the supported sequence.

This is also the clearest demonstration of why client-side checks cannot be a security control.
Modifying and re-signing an app is a handful of commands. Anything the app decided about itself
can be decided differently.

The defensive counterpart: because re-signing changes the signing key, the backend can
detect it. Play Integrity reports whether the installed binary matches what was distributed
through Play, and the backend verifies that signed verdict server-side. The attacker can change
the app; they cannot forge the platform's statement about it.

## Native Code

Where the logic is in a `.so` file, Java decompilation ends and binary analysis begins.

```bash
# What does the library export, and what does it depend on?
readelf --dyn-syms libnative.so | head
readelf -d libnative.so | head

# Cheap first pass
strings libnative.so | grep -i -E 'http|key|token'
```

Beyond that you need a disassembler with a decompiler: **Ghidra** is free and capable, and
**Radare2** or **Rizin** work from the command line. Functions exported for JNI have predictable
names of the form `Java_com_example_app_ClassName_methodName`, which gives you a reliable entry
point into an otherwise unlabelled binary.

Native code is also where memory-safety bugs live, so it earns disproportionate attention in an
assessment relative to its share of the codebase.

## iOS Binaries

An IPA is also a ZIP, and the static steps mirror the Android ones:

```bash
unzip -o app.ipa -d extracted
plutil -p extracted/Payload/MyApp.app/Info.plist
otool -L extracted/Payload/MyApp.app/MyApp
strings extracted/Payload/MyApp.app/MyApp | sort -u | head -40
```

Two differences matter:

- **Objective-C keeps its metadata.** Class names, method names and property names are present in
  the binary because the runtime needs them, so `class-dump` or a disassembler recovers a
  surprisingly complete interface. **Swift** emits mangled symbols and much less runtime metadata,
  so a Swift app reads less clearly.
- **App Store binaries are encrypted** with FairPlay, so `strings` on a store download yields
  almost nothing. Decrypting one requires a jailbroken device. Practice apps ship unencrypted.

## Dynamic Instrumentation with Frida

Static analysis tells you what the code can do. Dynamic instrumentation tells you what it does.
Frida injects a JavaScript engine into the target process and lets you inspect and replace
behaviour while the app runs.

Setup, on an emulator or a device you own: install the `frida-server` binary matching your Frida
version and device architecture, run it as root on the device, and drive it from the host.

```bash
# Running processes and installed apps on the attached USB device
frida-ps -Ua

# Attach to a running app
frida -U -n com.example.vulnerable

# Spawn the app and load a script before it initialises
frida -U -f com.example.vulnerable -l hook.js

# Trace every method of a class without writing a script
frida-trace -U -f com.example.vulnerable -j 'com.example.vulnerable.crypto.*!*'
```

A hook is small. This one logs the arguments and return value of one method in a lab app, which
is the shape of nearly every hook you will write:

```javascript
// hook.js - observe a method in your own lab app
Java.perform(function () {
  var Checker = Java.use("com.example.vulnerable.LicenseChecker");
  Checker.validate.implementation = function (code) {
    var result = this.validate(code);
    console.log("[*] validate(" + code + ") -> " + result);
    return result;
  };
});
```

Note that this hook calls the original method and returns its real result. Observing is where the
information is; replacing the return value demonstrates only that a local check is local, which
you already knew.

**Objection** packages the same capability as commands, which is faster for the routine tasks:

```bash
objection -g com.example.vulnerable explore
```

Inside the session: list the app's storage directories, enumerate classes and methods, inspect
live objects, and on iOS dump the Keychain for the app.

## Obfuscation

Obfuscation renames classes, methods and fields to meaningless identifiers, removes unused code,
and sometimes encrypts string constants. On Android, R8 does this as part of a release build; on
iOS, commercial tools do something similar.

What it achieves: a decompiled app full of `a.b.c(d)` takes considerably longer to understand, and
automated string-grepping finds less. It is a worthwhile cost increase and it is a sensible thing
for a vendor to do.

What it does not achieve: it does not protect data, it does not prevent instrumentation, and it
does not stop anyone determined. The program still has to make the same API calls and perform the
same cryptographic operations, and those calls are into platform classes whose names cannot be
obfuscated. Hooking `javax.crypto.Cipher` works no matter what the app's own classes are called.

So: **obfuscation is a cost control, not a security control.** Treat its absence as a low-severity
hardening note, never as the headline finding.

## Root and Jailbreak Detection

Apps that care about running in a modified environment check for it: the presence of an `su`
binary or known management packages, a writable system partition, the ability to open a package
manager URL scheme, a debugger attached, an unexpected signing certificate.

Every one of these is a function call inside the process the attacker is instrumenting, and
therefore every one can be hooked to return the convenient answer. The limit is structural rather
than a weakness of the tooling: a program cannot reliably attest to its own integrity using only
its own execution.

The controls that do work share one property: **the statement is made by something the attacker
does not control, and verified somewhere the attacker cannot reach.**

- **Play Integrity** on Android and **App Attest** on iOS produce a signed assertion about the
  device and app state. The backend verifies the signature. A hooked app cannot forge it.
- **Hardware-backed keys** in the Keystore or Secure Enclave are usable but not extractable, so a
  rooted device does not yield the key material.
- **Server-side enforcement** of every decision that matters. If the server never trusts the
  client's claim about entitlement, identity or balance, breaking the client gains nothing.

Keep local detection as telemetry (it is useful to know how much of your traffic comes from
modified environments) and keep decisions on the server.

## Lab Exercises

All against your own emulator and a deliberately vulnerable app:

1. `unzip -l` a practice APK and describe its structure. Does it contain native libraries?
2. `apktool d` it and enumerate every exported component from the decoded manifest.
3. `jadx -d` it and find, by reading: one hardcoded secret, one use of a weak cipher mode, and one
   place where a security decision is made locally.
4. Rebuild, re-sign with your own key, and install. Confirm the signing certificate changed.
5. Write one Frida hook that logs the arguments of a method you identified in step 3. Compare
   what it logs with what you predicted from the decompiled source.
6. Write down, for each of the three findings in step 3, the control that fixes it. That list is
   the actual deliverable.

## Key Takeaways

- APK and IPA are both ZIP archives. `unzip -l` before anything else.
- `apktool` for resources, the manifest and smali; `jadx` for readable Java. Decompilation is
  lossy, so fall back to smali when the output looks wrong.
- Native `.so` code needs a disassembler. JNI symbols give you labelled entry points.
- Objective-C retains runtime metadata and reads clearly; Swift reads much less clearly; App Store
  binaries are encrypted.
- Frida answers "what does this actually do at runtime" in seconds. Prefer observing to replacing.
- Obfuscation and root detection raise the attacker's cost. Attestation verified on the server,
  hardware-backed keys, and server-side enforcement are what actually hold.
- Reverse engineering someone else's app without authorisation is not a grey area. StGB §118a,
  the GDPR and the licence terms all apply. Module 01 has the detail; practice apps avoid the
  question entirely.

## Resources

- Apktool: <https://apktool.org/>
- jadx: <https://github.com/skylot/jadx>
- apksigner and zipalign (Android SDK build tools): <https://developer.android.com/tools>
- Frida documentation: <https://frida.re/docs/home/>
- Objection: <https://github.com/sensepost/objection>
- Ghidra: <https://ghidra-sre.org/>
- OWASP MASTG reverse engineering chapters and crackmes: <https://mas.owasp.org/MASTG/>
