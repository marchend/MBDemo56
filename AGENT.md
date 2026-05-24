# AcmeBank — Agent Context

## Project Overview
AcmeBank is an iOS 17+ banking app built in SwiftUI that lets customers view accounts,
review transactions, initiate transfers, and manage bill payments. It authenticates via
Okta OIDC and consumes a REST API over URLSession + async/await. The bootstrap PR ships
a Hello World shell; all features are delivered in follow-up stories.

## Tech Stack
| Item | Value |
|------|-------|
| Platform | iOS 17+, Xcode 16.0 |
| Language | Swift 5.10 |
| UI Framework | SwiftUI (`@main` App + WindowGroup) |
| Architecture | MVVM + Coordinator (`NavigationStack`) |
| Auth | Okta OIDC (`okta-mobile-swift` 2.x) |
| Networking | `URLSession` + async/await |
| DI | Constructor injection (no service locator) |
| Notifications | `NotificationCenter` with typed wrappers |
| Project file | XcodeGen (`project.yml`) — never edit `.pbxproj` |
| Tests | XCTest (unit), XCUITest (critical UI flows) |
| Linting | SwiftLint (`.swiftlint.yml`) |

## How to Run Locally
```bash
git clone <repo> && cd <repo>
./setup.sh        # installs xcodegen, generates .xcodeproj, opens Xcode
```
Manual fallback: `brew install xcodegen && xcodegen generate && open AcmeBank.xcodeproj`

## How to Run Tests
- Xcode: `Cmd+U`
- CLI: `xcodebuild test -scheme AcmeBank -destination 'platform=iOS Simulator,name=iPhone 16'`

## Key Directory Structure
```
project.yml               # XcodeGen spec (source of truth)
setup.sh                  # one-shot project materialisation
AcmeBank/
  App/                    # @main entry, RootView, AppCoordinator
  Core/Auth/              # AuthService, KeychainStore, UserSession
  Core/Networking/        # APIClient, APIRouter, APIError, RequestInterceptor
  Core/Notifications/     # AppNotification, NotificationPublisher
  Core/Extensions/        # Decimal+Currency, Date+Greeting, String+Initials
  Domain/Models/          # Account, Transaction, Customer, TransferRequest
  Domain/Repositories/    # Protocol-only repository definitions
  Data/Remote/            # API-backed repository implementations
  Data/Mock/              # Hardcoded fixture repositories (used in tests/previews)
  Features/Login/         # LoginView, LoginViewModel, LoginCoordinator
  Features/Home/          # HomeView, HomeViewModel, HomeCoordinator + subviews
  Features/Accounts/      # (future)
  Features/Transfer/      # (future)
  Features/Cards/         # (future)
  DesignSystem/           # Colors.swift, Typography.swift, Assets.xcassets
  Resources/              # Assets.xcassets (AcmeBankLogo), Localizable.strings
AcmeBankTests/            # XCTest unit tests mirroring app structure
AcmeBankUITests/          # XCUITest critical-flow tests (login, transfer, sign-out)
```

## Planned Architecture

### MVVM + Coordinator (deferred — future PR)
- **View**: SwiftUI struct; renders `@Published` state, no business logic.
- **ViewModel**: `final class: ObservableObject`; calls repositories, sets `@Published` state.
- **Coordinator**: `ObservableObject`; owns `NavigationPath`, creates child View+VM pairs.
- **Repository protocols** in `Domain/`; concrete types in `Data/`; VMs depend only on protocols.

### Authentication — Okta OIDC (deferred — future PR)
`AuthService` wraps `okta-mobile-swift`; persists tokens via `KeychainStore`; returns `UserSession`.
`RequestInterceptor` calls `refreshTokenIfNeeded()` before every request; posts
`AppNotification.sessionExpired` on failure.

### Networking (deferred — future PR)
`APIClient` wraps `URLSession`; decodes with `.convertFromSnakeCase` + `.iso8601`.
`APIRouter` enum expresses every endpoint with `path`, `method`, `body`, `queryItems`.
`API_BASE_URL` read from `Info.plist`; injected via xcconfig in CI.

### Domain Models (deferred — future PR)
`Account`, `Transaction`, `Customer`, `TransferRequest` — all `Codable` value types.

### Repository Protocols (deferred — future PR)
`AccountRepositoryProtocol`, `TransactionRepositoryProtocol`, `CustomerRepositoryProtocol`,
`TransferRepositoryProtocol`. All VMs depend on the protocol, never the concrete type.

### Mock Data Layer (deferred — future PR)
`MockAccountRepository` etc. return hardcoded fixtures; used in unit tests and Xcode Previews.

### Design System (deferred — future PR)
`Color` extensions (`acmeNavy`, `acmeBackground`, …) and `Font` extensions (`acmeTitle`, …).

### Internal Notifications (deferred — future PR)
`AppNotification` typed `Notification.Name` constants; `NotificationPublisher` static helper.
`AppCoordinator` subscribes via Combine; Views use `.onReceive`.

### CI (deferred — future PR)
`ios-build.yml`: `xcodebuild test`, SwiftLint, `-warnings-as-errors`, xcconfig secret injection.

### XCUITest
`AcmeBankUITests/` target; critical flows: login, transfer confirmation, sign-out.
Uses `launchArguments += ["-UITestMode", "YES"]` to swap in mock repositories.
The login screen also honors `-UITestShowErrorBanner` to pre-populate
`LoginViewModel.errorMessage` so XCUITest can assert the inline error banner without an auth backend.

## Implemented

### Bootstrap PR
- `project.yml` XcodeGen spec ✅
- `AcmeBank/App/AcmeBankApp.swift` — `@main` SwiftUI entry ✅
- `AcmeBank/App/ContentView.swift` — Hello World placeholder view ✅
- `AcmeBankTests/AcmeBankTests.swift` — bootstrap proof-of-life test ✅
- `setup.sh`, `.gitignore` ✅

### PR 1 — Login Screen UI (MD056-3)
- `AcmeBank/Features/Login/LoginViewModel.swift` — ObservableObject with `username`, `password`, `isSignInEnabled`, `attemptSignIn()` ✅
- `AcmeBank/Features/Login/LoginView.swift` — SwiftUI login screen with accessibility identifiers ✅
- `AcmeBank/Features/Login/LoginView+Previews.swift` — light/dark/accessibility-size previews ✅
- `AcmeBank/Resources/Assets.xcassets/AcmeBankLogo.imageset/` — logo image asset ✅
- `AcmeBank/App/AcmeBankApp.swift` — wired `LoginView` as root (replaced `ContentView`) ✅
- `AcmeBankTests/Features/Login/LoginViewModelTests.swift` — 6 unit tests ✅
- `AcmeBankUITests/Features/Login/LoginViewUITests.swift` — 4 XCUITest cases ✅
- `project.yml` — added `AcmeBankUITests` target + scheme entry ✅

### PR 1 — Login Screen UI completion (MD056-4)
- `LoginViewModel` — `onSignIn` widened to `(String, String, Bool) -> Void`; added `@Published keepSignedIn` and `@Published errorMessage` ✅
- `LoginView` — added "Keep me signed in" `Toggle` (id `login_keep_signed_in_toggle`) and inline red error banner (id `login.errorBanner`) ✅
- `AcmeBankApp` — honors `-UITestShowErrorBanner` launch arg to pre-set `errorMessage` for XCUITest ✅
- Unit + XCUITest coverage extended for the new closure signature, toggle, and banner ✅

## Deferred Work
- Real Okta OIDC `signIn` closure wiring (follow-on story)
- RootView + AppCoordinator (auth-state switching)
- Home, Accounts, Transfer, Cards screens
- Networking layer (APIClient, APIRouter, RequestInterceptor)
- Domain models and repository protocols
- Remote and mock repository implementations
- Design system (Colors, Typography)
- Internal notification infrastructure
- SwiftLint configuration
- CI pipeline (ios-build.yml)
- Keychain store
- Localizable.strings

## Git Workflow

> **Default PR target branch: `develop`.** Every feature/refactor/docs PR
> opens against `develop`. PRs are only opened against `qa`, `uat`, or
> `main` for explicit promotion PRs.

**Branch model (`develop` → `qa` → `uat` → `main`):**

| Branch  | Role                                 | Receives PRs from              | Promotes to |
|---------|--------------------------------------|--------------------------------|-------------|
| develop | Default integration branch           | feature branches               | qa          |
| qa      | First quality gate                   | develop (promotion PR)         | uat         |
| uat     | Pre-prod acceptance                  | qa (promotion PR)              | main        |
| main    | Production / release tags            | uat (promotion PR)             | tagged only |

All feature PRs MUST target `develop`. Never open a feature PR against
`qa`, `uat`, or `main`. Promotions happen via dedicated promotion PRs.
