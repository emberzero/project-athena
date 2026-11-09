#import "../../../typst-theme-emberzero/1.1.0/src/lib.typ": *

#show: athena-theme.with(
  font: "Berkeley Mono",
  config-info(
    title: [Module 18: Mobile Security],
    subtitle: [The Most Personal Computer],
    authors: [*Project Athena*],
    extra: [],
    footer: [Module 18 - Mobile Security],
  ),
  config-common(
    handout: false,
  ),
)

#title-slide()

#section-slide(title: "Introduction")

#slide(title: "Why Mobile Is Different")[
  - The device can be *lost or stolen*: physical access is an everyday event
  - The *attacker may be the owner*: the client runs on hardware they control
  - Code arrives through an *app store*: a real control, and a single point of trust
  - *Updates* are not under your control; many devices run unpatched
  - Sensors and radios widen the attack surface

  #cblock(title: [The consequence])[
    Every trust decision that matters must be made on the *server*.
  ]
]

#slide(title: "The Threat Model: Four Attackers")[
  #table(
    columns: (auto, 1fr),
    inset: 6pt,
    stroke: 0.5pt + gray,
    [*Remote*], [Reaches only the app and backend API (softest part)],
    [*Network path*], [Hostile AP; defeated by TLS done correctly],
    [*Malicious app*], [Co-installed, reaches what another app exposes],
    [*Physical access*], [Extracts storage, hooks the process],
  )

  The last two are specific to mobile, and most of this module is about them.
]

#slide(title: "Standards and the Lab")[
  #split(
    [
      *Reference material*
      - MASVS: the requirements (a checklist)
      - MASTG: the test cases (the how-to)
      - Both free, OWASP
    ],
    [
      *Your lab*
      - Android emulator (`adb root`)
      - An old physical phone
      - Deliberately vulnerable apps: DIVA, InsecureBankv2, DVIA
    ],
  )

  #cblock(title: [Legal], color: red.darken(20%))[
    A phone is a computer system: StGB §118a, §126a, §126b. App data is personal data (GDPR). Authorisation *in writing*.
  ]
]

#section-slide(title: "Device Architecture")

#slide(title: "A Phone Is Several Processors")[
  - *Application processor:* runs the OS and all apps
  - *Baseband:* the cellular modem, own firmware, isolated from app memory
  - *TEE* (ARM TrustZone): isolated mode holding secrets the OS cannot read
  - *Secure element:* separate chip for the highest-value secrets
  - *Sensors and radios:* each has firmware, each is an input

  "The device was compromised" is not one statement: root on the app processor does not give you the TEE.
]

#slide(title: "The Chain of Trust")[
  #align(center + horizon, image("../lectures/images/boot-chain.svg", height: 60%))

  Platforms trust immutable *Boot ROM*, then verify each stage's signature before running it. Android Verified Boot exposes a boot state (green / yellow / orange). Unlocking the bootloader *wipes user data*.
]

#slide(title: "Storage Encryption")[
  - Key derived from a *hardware-bound key* plus the user's passcode
  - The flash chip alone is useless; secure hardware *rate-limits* passcode attempts
  - File-based encryption: some data readable only after first unlock
  - iOS calls this *Data Protection classes*, chosen per file

  A locked, powered-off phone with a strong passcode is a hard target. The same phone unlocked, or with a weak PIN, is not.
]

#slide(title: "Sandbox, Permissions, Updates")[
  #cblock(title: [The app sandbox])[
    Each app gets its own identity and private storage, and cannot read another app's data. Everything beyond is mediated by the platform.
  ]

  - IPC, shared storage, clipboard, logs *cross the sandbox*: validate them
  - Permissions gate camera, mic, location... asked in context
  - Least privilege is a design decision; a denied permission must be a working state
  - Updates are the best control and the hardest to rely on
]

#slide(title: "Where the Boundary Sits")[
  ```text
  App A | App B | App C      <- isolated by the OS
  ---------------------------
  OS: permissions, IPC       <- root lives here
  ---------------------------
  TEE / secure element       <- survives root
  ---------------------------
  Boot ROM: root of trust    <- survives everything
  ```

  Baseband and Wi-Fi firmware sit outside the OS trust boundary, reachable over the air.
]

#section-slide(title: "Android Security")

#slide(title: "One UID Per App")[
  #align(center + horizon, image("../lectures/images/android-stack.svg", height: 58%))

  Every app is a different Linux user; its private directory is readable by nobody else. *SELinux* (enforcing since 5.0) confines even root to its policy domain, so a root exploit in one component is not access to everything.
]

#slide(title: "The Permission Model")[
  #table(
    columns: (auto, 1fr),
    inset: 6pt,
    stroke: 0.5pt + gray,
    [*Normal*], [Granted automatically, low risk (`INTERNET`)],
    [*Dangerous*], [Runtime prompt: camera, location, SMS (since 6.0)],
    [*Signature*], [Only apps signed with the same key],
    [*Special access*], [Accessibility, overlays: enabled in Settings, powerful],
  )

  Request the minimum, at the point of use, and handle refusal as a normal path.
]

#slide(title: "Exported Components")[
  An app is a set of components the system can start: *activity, service, broadcast receiver, content provider*. Each can be *exported*.

  ```bash
  adb shell am start -n com.example.vuln/.AdminActivity
  adb shell content query --uri \
    content://com.example.vuln.provider/users
  ```

  If `am start` opens an admin screen the login was meant to protect, the login was never a control, only navigation.
]

#slide(title: "Guarding the Exported Surface")[
  - `android:exported="false"` for anything internal
  - A *signature* permission for IPC only your own apps should reach
  - An authorisation check *inside* the component (an exported one still decides if this caller may do this)
  - Since Android 12, an intent-filtered component must declare `exported` explicitly

  Treat intents, deep links and WebView content as *untrusted network input*.
]

#slide(title: "Deep Links and WebView")[
  #split(
    [
      *Deep links*
      - Implicit intents can leak data to any matching app
      - App Links verified via `assetlinks.json`
      - Custom `myapp://` can be claimed by anyone
    ],
    [
      *WebView*
      - `addJavascriptInterface` bridges web to app code
      - File access can read local files
      - Never proceed on a TLS error
    ],
  )
]

#slide(title: "Storage and Keystore")[
  #table(
    columns: (auto, 1fr),
    inset: 5pt,
    stroke: 0.5pt + gray,
    [Internal storage], [The app's UID only],
    [`SharedPreferences`], [Plain XML: readable with root or a backup],
    [External storage], [Other apps (scoped storage rules)],
    [Logcat / clipboard], [Reachable by tooling / any app],
  )

  Use `EncryptedSharedPreferences` or the *Keystore*: a hardware-backed key is usable but not extractable, so a full filesystem dump does not yield it.
]

#slide(title: "Network and Platform Defences")[
  - Cleartext HTTP blocked by default; config in `network_security_config`
  - *Certificate pinning* defeats an interception proxy, but can be hooked out on a device the attacker owns: raises cost, not a guarantee
  - User-installed CAs untrusted by apps since Android 7.0
  - *Play Integrity API:* a signed verdict the backend verifies, far stronger than an in-app root check

  Root detection is easy to write and easy to bypass: use it as telemetry.
]

#section-slide(title: "iOS Security")

#slide(title: "Code Signing Is the Centre")[
  The kernel refuses to execute pages without a valid signature.

  - An app *cannot download and run* new native code
  - Memory is not both writable and executable: removes a family of exploits
  - Installing needs a signature from Apple, enterprise, or a dev profile

  *Entitlements* (a signed plist) list what the app may reach; reading them is one of the first static steps. Dynamic analysis usually needs a *jailbroken* device.
]

#slide(title: "Secure Enclave and Containers")[
  - *Secure Enclave:* separate coprocessor, device-unique fused key, does biometric matching. Biometric data never leaves it; it answers only yes/no
  - A six-digit passcode is strong because the hardware *will not let you try quickly*

  ```text
  Bundle container  read-only, signed (the app)
  Data container    Documents/   <- in backups
                    Preferences/ <- NSUserDefaults
                    Caches/      <- often forgotten
  ```

  App groups are a deliberate hole in the sandbox: share only what must be shared.
]

#slide(title: "Keychain, Data Protection, ATS")[
  - *Keychain:* the place for credentials; each item has an accessibility attribute. Pick the most restrictive the feature tolerates (`WhenUnlocked`, `ThisDeviceOnly`)
  - `NSUserDefaults` and `Documents` are backed up: not a secret store
  - *App Transport Security:* HTTPS required by default

  #cblock(title: [A finding], color: red.darken(20%))[
    `NSAllowsArbitraryLoads` set true disables ATS app-wide: every request may travel in cleartext.
  ]
]

#slide(title: "Android and iOS Side by Side")[
  #table(
    columns: (auto, 1fr, 1fr),
    inset: 5pt,
    stroke: 0.5pt + gray,
    [*Concern*], [*Android*], [*iOS*],
    [Identity], [UID + signing key], [Signature + entitlements],
    [Isolation], [UID + SELinux], [Sandbox + container],
    [Secrets], [Keystore (TEE)], [Keychain (Enclave)],
    [Attestation], [Play Integrity], [App Attest],
    [Owner escape], [Rooting], [Jailbreaking],
  )

  Once you name a control on one platform, ask what plays its role on the other.
]

#section-slide(title: "Mobile App Security")

#slide(title: "The Central Assumption")[
  #align(center + horizon, image("../lectures/images/app-trust-boundaries.svg", height: 54%))

  *The app runs on hardware the attacker controls.* Storage can be read, traffic intercepted, the binary decompiled. That is the environment, not a vulnerability. The *finding* is the consequence.
]

#slide(title: "MASVS Categories as a Test Plan")[
  #split(
    [
      - *Storage:* what is written, who reads it
      - *Crypto:* hardcoded keys, ECB, home-made ciphers
      - *Auth:* happens on the *server*
    ],
    [
      - *Network:* cleartext, broken TLS validation
      - *Platform:* exported surface, deep links, WebView
      - *Resilience:* obfuscation = cost, not safety
    ],
  )

  #cblock(title: [Where the severe findings are])[
    The backend API is usually where the data lives. The app is how you find the API.
  ]
]

#slide(title: "Tooling")[
  #table(
    columns: (auto, 1fr),
    inset: 6pt,
    stroke: 0.5pt + gray,
    [*MobSF*], [Static: unpacks, decompiles, reports. Lead list, not a report],
    [*Frida*], [Injects a JS engine to inspect a running process],
    [*Objection*], [Frida toolkit with ready-made commands],
  )

  Automated tools produce *leads*. Every item needs a human to decide whether it is exploitable.
]

#slide(title: "A Workable Assessment Order")[
  1. Get the app (the version you are authorised to test)
  2. Static pass: manifest, permissions, exported surface, SDKs
  3. Decompile and read: crypto, secrets, TLS handling
  4. Storage pass: use it, then look at what it wrote
  5. Network pass: proxy, map the API, test its *authorisation*
  6. Platform pass: poke exported components and deep links
  7. Dynamic pass: hook the functions the static pass flagged
  8. Write up: impact first, repro, the fixing control
]

#section-slide(title: "Reverse Engineering Apps")

#slide(title: "APK and IPA Are ZIP Archives")[
  ```text
  app.apk
    AndroidManifest.xml   components, permissions
    classes.dex           Dalvik bytecode
    resources.arsc        compiled resources
    lib/arm64-v8a/*.so    native libraries, if any
    META-INF/             the signature
  ```

  ```bash
  unzip -l app.apk
  ```

  A `lib/` directory means part of the logic is compiled C/C++ and will not appear in any Java decompilation.
]

#slide(title: "The Android Toolchain")[
  #table(
    columns: (auto, 1fr),
    inset: 6pt,
    stroke: 0.5pt + gray,
    [`apktool`], [Decodes manifest and resources; DEX to *smali*; rebuilds],
    [`jadx`], [Decompiles DEX to readable Java; `jadx-gui` to navigate],
  )

  Decompilation is lossy: synthetic names, odd control flow. When the Java looks wrong, read the smali, which is ground truth.

  Look first at: the manifest, strings, crypto use, the network layer, native libraries.
]

#slide(title: "Re-signing Proves the Point")[
  ```bash
  apktool b app-decoded -o patched.apk
  zipalign -p 4 patched.apk patched-aligned.apk
  apksigner sign --ks lab.keystore \
    --out patched-signed.apk patched-aligned.apk
  adb install patched-signed.apk
  ```

  Modifying and re-signing an app is a handful of commands. *Anything the app decided about itself can be decided differently.* The backend detects the changed signing key via Play Integrity.
]

#slide(title: "Native and iOS Binaries")[
  #split(
    [
      *Native `.so`*
      - Java decompilation ends
      - `readelf`, then Ghidra / radare2
      - JNI names like `Java_com_...` give entry points
      - Where memory bugs live
    ],
    [
      *iOS*
      - Objective-C keeps metadata, reads clearly
      - Swift: mangled, reads less
      - Store binaries FairPlay-encrypted
    ],
  )
]

#slide(title: "Dynamic Instrumentation with Frida")[
  Static tells you what the code *can* do; Frida tells you what it *does*.

  ```javascript
  Java.perform(function () {
    var C = Java.use("com.example.vuln.LicenseChecker");
    C.validate.implementation = function (code) {
      var r = this.validate(code);
      console.log("validate(" + code + ") -> " + r);
      return r;
    };
  });
  ```

  Prefer *observing* to replacing: replacing only proves a local check is local.
]

#slide(title: "What Actually Holds")[
  Obfuscation and root/jailbreak detection run *inside the process the attacker controls*, so both can be hooked. They raise cost, not safety.

  #cblock(title: [The controls that work share one property])[
    The statement is made by something the attacker does not control, and verified somewhere they cannot reach.
  ]

  - Play Integrity / App Attest, verified server-side
  - Hardware-backed keys: usable, not extractable
  - Server-side enforcement of every decision that matters
]

#standout-slide(title: [Any check the app runs on itself can be changed. Only the server's decision is durable.])
