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
    private static func makeLoginViewModel() -> LoginViewModel {
        let viewModel = LoginViewModel()
        let arguments = ProcessInfo.processInfo.arguments
        if arguments.contains("-UITestShowErrorBanner") {
            viewModel.errorMessage = "Invalid username or password."
        }
        return viewModel
    }
}
