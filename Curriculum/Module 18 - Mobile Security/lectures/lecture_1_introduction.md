# Introduction to Mobile Security

Mobile devices are the most personal computers most people own. A phone carries messages,
photographs, location history, payment credentials, health data and a second factor for every
other account its owner has. It also carries a dozen radios, a camera, a microphone and a set of
sensors, and it goes everywhere its owner goes. That combination is why mobile security is a
separate discipline rather than a footnote to web or desktop security.

This lecture sets up the rest of the module: what makes the mobile platform different, who attacks
it and why, which standards the industry uses as a reference, and the rules you work under when
you test.

## Why Mobile Is Different

### The device can be lost or stolen

A server sits in a locked room. A phone sits on a tram seat. Physical access, which is the
end of most threat models on a desktop, is an everyday event for a phone. Mobile platforms
therefore assume that an attacker may eventually hold the hardware, and push hard on full-device
encryption, hardware-backed key storage and a lock screen that is genuinely in the way.

### The attacker may be the device owner

This is the inversion that surprises people coming from web security. On the web, the client is
hostile and the server is yours. On mobile, the client is an app you shipped, running on a device
the user fully controls - and that user may be the attacker, trying to unlock paid features, cheat
in a game, or forge a loyalty balance. Anything the app decides locally can be changed. Every
trust decision that matters has to be made on the server.

### Code arrives through an app store

Users do not compile apps. They install signed packages from a store that reviews them, scans
them, and can pull them back. This is a real security control, and it is also a single point of
trust: a malicious app that passes review reaches millions of devices, and an app sideloaded
outside the store skips the control entirely.

### Updates are not under your control

A browser updates itself weekly. A phone updates when the vendor ships an image and the carrier
approves it, and a cheap Android device may stop receiving updates a year or two after release.
Large numbers of devices in the field therefore run software with known, unpatched defects. That
is a structural property of the ecosystem, not a user mistake.

### Sensors and radios widen the surface

Microphone, camera, GPS, accelerometer, Bluetooth, NFC, cellular baseband, Wi-Fi. Each is an input
the app can read with permission and an attack surface the platform has to defend. Much of the
mobile permission model exists because of this list.

## The Threat Model

It helps to name the attacker before discussing defences. Mobile assessments usually consider
four:

- **A remote attacker with no access to the device.** Reaches the app only through the network and
  through the backend API. This is ordinary application security, and the backend API is usually
  the softest part of a mobile product.
- **An attacker on the network path.** A hostile access point, a rogue hotspot, a compromised
  router. Wants to read or modify traffic. Defeated by TLS done correctly - which is why cleartext
  traffic and sloppy certificate validation are such frequent findings.
- **A malicious app on the same device.** Installed by the user, holds no special privileges, and
  tries to reach another app's data through whatever that app accidentally exposes: world-readable
  files, exported components, loose deep links, logs, the clipboard.
- **An attacker with the unlocked or unlockable device in hand.** Extracts data from storage,
  attaches a debugger, hooks the running process. Against this attacker, client-side defences buy
  time rather than safety.

The last two are specific to mobile, and most of this module is about them.

## Standards and Reference Material

You do not have to invent a methodology. Two bodies of work are the common language:

- **OWASP MASVS** (Mobile Application Security Verification Standard) is the requirements
  document: a list of security properties a mobile app should have, grouped into categories such
  as storage, cryptography, authentication, network communication, platform interaction and
  resilience. Use it as a checklist when deciding what to test.
- **OWASP MASTG** (Mobile Application Security Testing Guide) is the how-to: concrete test cases
  for Android and iOS that correspond to the MASVS requirements, plus a set of deliberately
  vulnerable practice apps.

Both are free and maintained in the open. Anything in this module that looks like a checklist is
a condensed form of MASVS; the hands-on parts follow MASTG.

## Platform Comparison at a Glance

| Property | Android | iOS |
| --- | --- | --- |
| Base system | Linux kernel, open source core (AOSP) | Darwin kernel, closed source |
| App isolation | One Linux UID per app, plus SELinux | Sandbox profile per app, container per app |
| App language | Kotlin/Java on ART, plus native code via NDK | Swift/Objective-C compiled to Mach-O |
| Package format | APK (a ZIP), or AAB for distribution | IPA (a ZIP containing an app bundle) |
| Distribution | Play Store, other stores, sideloading possible | App Store, plus enterprise and developer channels |
| Privilege escape by owner | Rooting | Jailbreaking |
| Hardware key storage | Keystore backed by TEE or secure element | Keychain backed by the Secure Enclave |

The architectures differ in detail but converge on the same four ideas: verify the boot chain,
isolate each app, keep keys in hardware, and gate sensitive capabilities behind permissions. The
next lecture looks at those ideas as a layered model.

## Your Lab

Everything hands-on in this module runs against something you own:

- An **Android emulator** (an AVD created with Android Studio, or `avdmanager` from the command
  line). Use a system image without Google Play so that the emulator gives you a root shell via
  `adb root`. Emulator networking puts the host at `10.0.2.2` from the guest's point of view.
- An **old physical Android phone**, if you have one, for the things an emulator cannot do:
  real sensors, real radios, hardware-backed Keystore behaviour.
- **Deliberately vulnerable practice apps**, which is what you should actually attack. The MASTG
  crackmes, and training apps such as InsecureBankv2 or DIVA for Android and DVIA for iOS, exist
  precisely so that nobody has to point tools at real software.

iOS work has a hardware floor: you cannot run a meaningful iOS dynamic analysis in a simulator on
a non-Apple machine, and the interesting instrumentation needs a jailbroken device. Where that is
out of reach, the iOS lecture stays on static analysis of an IPA, which needs only a laptop.

## Legal Framing

Austrian and EU law applies to anything you do here, and the rules are not softened by the device
being small.

- Accessing a computer system or data you are not authorised to access is criminal under
  **StGB §118a**. Damaging data is **§126a**, disrupting the function of a system is **§126b**.
  A phone is a computer system.
- Mobile app data is almost always personal data, so the **GDPR** applies to anything you extract,
  copy or store during an assessment - including the test data you pull off a device and forget
  to delete.
- Rooting or jailbreaking is yours to do on hardware you own. It is not yours to do on a device
  that belongs to someone else, including a school or employer device.
- An authorisation to test is worth something only in writing, naming the apps, the backend hosts,
  the devices and the time window. "Someone said it was fine" is not a defence.

Module 01 covers the detail. Read it before you touch anything that is not yours.

## Key Takeaways

- Mobile security differs from web security mainly in two ways: the device can be lost, and the
  user may be the attacker. Both push trust towards hardware and towards the server.
- Any check an app performs on itself - licence state, root detection, feature entitlement - runs
  on hardware the attacker controls and can therefore be changed. Server-side enforcement is the
  only durable form.
- The four attackers worth modelling are: remote, network path, malicious co-installed app,
  and physical access.
- MASVS gives you the requirements, MASTG gives you the test cases. Use them rather than improvising.
- Practise on an emulator and on apps built to be attacked. Written authorisation first, always.

## Resources

- OWASP Mobile Application Security project (MASVS and MASTG): <https://mas.owasp.org/>
- Android Platform Security Model and security documentation: <https://source.android.com/docs/security>
- Apple Platform Security guide: <https://support.apple.com/guide/security/welcome/web>
- Austrian criminal code, StGB §118a, §126a, §126b: <https://www.ris.bka.gv.at/>
