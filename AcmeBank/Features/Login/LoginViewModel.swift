import Foundation

final class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""

    /// Tracks whether the password field is in plain-text (revealed) mode.
    @Published var isPasswordRevealed: Bool = false

    /// Whether the "Keep me signed in" checkbox is checked. Defaults to unchecked per AC.
    @Published var keepMeSignedIn: Bool = false

    /// Controls presentation of the "Need help?" modal sheet.
    @Published var isNeedHelpPresented: Bool = false

    // NOTE: `isSignInEnabled` is intentionally a plain computed property rather than
    // `@Published`. SwiftUI re-evaluates the view whenever `username` or `password`
    // (both `@Published`) change, so the button state updates correctly via
    // `@ObservedObject`. It is NOT observable via Combine's `sink` — do not add a
    // subscriber expecting to receive updates on `isSignInEnabled` directly; subscribe
    // to `username`/`password` instead.
    var isSignInEnabled: Bool {
        !username.isEmpty && !password.isEmpty
    }

    let signIn: () -> Void

    init(signIn: @escaping () -> Void = {}) {
        self.signIn = signIn
    }

    func attemptSignIn() {
        guard isSignInEnabled else { return }
        signIn()
    }
}
