import Foundation

/// View model for the login screen.
///
/// PR 1 widens the sign-in closure from `() -> Void` to
/// `(String, String, Bool) -> Void` so a follow-up PR can plug Okta in
/// without further changes to the view. It also exposes a
/// `keepSignedIn` toggle state and an `errorMessage` for the inline
/// error banner. No Okta SDK is referenced here.
final class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var keepSignedIn: Bool = false
    @Published var errorMessage: String?

    var isSignInEnabled: Bool {
        !username.isEmpty && !password.isEmpty
    }

    /// Invoked with the typed `(username, password, keepSignedIn)` when
    /// the user taps Sign In and both credential fields are non-empty.
    let onSignIn: (String, String, Bool) -> Void

    init(onSignIn: @escaping (String, String, Bool) -> Void = { _, _, _ in }) {
        self.onSignIn = onSignIn
    }

    func attemptSignIn() {
        guard isSignInEnabled else { return }
        // Snapshot the credentials, then zero the `@Published` fields
        // before handing off to `onSignIn`. This minimises how long the
        // plain-text password lingers on the heap — important for a
        // banking app, and much harder to retrofit once the follow-up
        // Okta call introduces an `await` point between the snapshot
        // and the network request.
        let capturedUsername = username
        let capturedPassword = password
        let capturedKeepSignedIn = keepSignedIn
        username = ""
        password = ""
        onSignIn(capturedUsername, capturedPassword, capturedKeepSignedIn)
    }
}
