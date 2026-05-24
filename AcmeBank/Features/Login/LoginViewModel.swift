import Foundation

final class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""

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
