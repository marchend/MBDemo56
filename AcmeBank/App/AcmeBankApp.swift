import SwiftUI

@main
struct AcmeBankApp: App {
    var body: some Scene {
        WindowGroup {
            LoginView(viewModel: Self.makeLoginViewModel())
        }
    }

    /// Build the login view model and apply UI-test hooks if the app
    /// was launched with the corresponding launch arguments. Used by
    /// XCUITest to render the error banner without wiring a real auth
    /// backend.
    ///
    /// The UI-test hook is wrapped in `#if DEBUG` so the launch-argument
    /// branch is stripped at compile time from Release / App Store
    /// builds. This prevents a production binary from ever rendering
    /// the fake error banner if `-UITestShowErrorBanner` happened to be
    /// present in `ProcessInfo.processInfo.arguments` (e.g. via a
    /// misconfigured Instruments launch or an MDM-managed device).
    private static func makeLoginViewModel() -> LoginViewModel {
        let viewModel = LoginViewModel()
        #if DEBUG
        let arguments = ProcessInfo.processInfo.arguments
        if arguments.contains("-UITestShowErrorBanner") {
            viewModel.errorMessage = "Invalid username or password."
        }
        #endif
        return viewModel
    }
}
