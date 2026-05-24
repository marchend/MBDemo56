# Bootstrap Plan — AcmeBank iOS

## In scope (this PR)

### Project name + tech stack
- **App name:** AcmeBank
- **Platform:** iOS 17+, Swift 5.10
- **UI Framework:** SwiftUI (spec §1)
- **Project generation:** XcodeGen (`project.yml`) — never hand-craft `.xcodeproj`
- **Test runner:** XCTest (unit test target only for bootstrap)
- **Bundle ID:** `com.acmebank.mobile`
- **Min Xcode:** 16.0

### Directory structure (bootstrap only)
```
AcmeBank/
├── project.yml                  # XcodeGen spec
├── setup.sh                     # one-shot: xcodegen generate + open Xcode
├── .gitignore                   # iOS / XcodeGen / macOS noise
├── README.md                    # updated with setup instructions
├── bootstrap_plan.md            # this file
├── CLAUDE.md                    # agent context (full planned architecture)
├── AGENT.md                     # identical to CLAUDE.md
├── AcmeBank/
│   └── App/
│       ├── AcmeBankApp.swift    # @main SwiftUI App entry (WindowGroup)
│       └── ContentView.swift   # Hello World placeholder view
└── AcmeBankTests/
    └── AcmeBankTests.swift      # ONE trivial test — proves XCTest links
```

### Files this PR creates
| File | Purpose |
|------|---------|
| `project.yml` | XcodeGen declarative project spec |
| `setup.sh` | Clone → build in one command |
| `.gitignore` | Prevent generated artifacts being committed |
| `CLAUDE.md` / `AGENT.md` | Full architecture docs for future agents |
| `AcmeBank/App/AcmeBankApp.swift` | `@main` SwiftUI entry point |
| `AcmeBank/App/ContentView.swift` | Hello World SwiftUI view |
| `AcmeBankTests/AcmeBankTests.swift` | Bootstrap proof-of-life test |

### How to run locally
```bash
git clone <repo>
cd <repo>
./setup.sh          # installs xcodegen if needed, generates .xcodeproj, opens Xcode
```
Manual fallback: `brew install xcodegen && xcodegen generate && open AcmeBank.xcodeproj`

### How to run tests
In Xcode: `Cmd+U`  
On CLI: `xcodebuild test -scheme AcmeBank -destination 'platform=iOS Simulator,name=iPhone 16'`

### Definition of Hello World
App launches on iPhone simulator showing a centred "AcmeBank" title text on a white background. One unit test (`test_contentView_initializes`) confirms the test target compiles and links against the app module.

---

## Out of scope — deferred to future work

- **Authentication (Okta OIDC via `okta-mobile-swift`)** — future PR
- **RootView + AppCoordinator (auth-state switching)** — future PR
- **MVVM + Coordinator pattern wiring** — future PR
- **Networking layer (APIClient, APIRouter, APIError, RequestInterceptor)** — future PR
- **Domain models (Account, Transaction, Customer, TransferRequest)** — future PR
- **Repository protocols (AccountRepository, TransactionRepository, etc.)** — future PR
- **Remote API repositories (AccountAPIRepository, etc.)** — future PR
- **Mock data layer (MockAccountRepository, etc.)** — future PR
- **Login feature (LoginView, LoginViewModel, LoginCoordinator)** — future PR
- **Home feature (HomeView, HomeViewModel, HomeCoordinator)** — future PR
- **Accounts, Transfer, Cards features** — future PR
- **Design system (Colors.swift, Typography.swift, Assets.xcassets)** — future PR
- **Internal notifications (AppNotification, NotificationPublisher)** — future PR
- **Core extensions (Decimal+Currency, Date+Greeting, String+Initials)** — future PR
- **Keychain store (KeychainStore.swift)** — future PR
- **XCUITest target + critical-flow UI tests** — future PR
- **SwiftLint configuration (.swiftlint.yml)** — future PR
- **CI pipeline (ios-build.yml, xcconfig secret injection)** — future PR
- **Okta.plist.example** — future PR
- **Localizable.strings** — future PR
