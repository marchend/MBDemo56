import XCTest
@testable import AcmeBank

final class LoginViewModelTests: XCTestCase {

    // MARK: - isSignInEnabled

    func test_signInDisabled_whenFieldsEmpty() {
        let sut = LoginViewModel()
        XCTAssertFalse(sut.isSignInEnabled)
    }

    func test_signInDisabled_whenOnlyUsernameProvided() {
        let sut = LoginViewModel()
        sut.username = "user@acmebank.com"
        XCTAssertFalse(sut.isSignInEnabled)
    }

    func test_signInDisabled_whenOnlyPasswordProvided() {
        let sut = LoginViewModel()
        sut.password = "s3cr3tP@ss"
        XCTAssertFalse(sut.isSignInEnabled)
    }

    func test_signInEnabled_whenBothFieldsFilled() {
        let sut = LoginViewModel()
        sut.username = "user@acmebank.com"
        sut.password = "s3cr3tP@ss"
        XCTAssertTrue(sut.isSignInEnabled)
    }

    // MARK: - attemptSignIn

    func test_attemptSignIn_invokesClosureWhenEnabled() {
        var closureInvoked = false
        let sut = LoginViewModel(signIn: { closureInvoked = true })
        sut.username = "user@acmebank.com"
        sut.password = "s3cr3tP@ss"

        sut.attemptSignIn()

        XCTAssertTrue(closureInvoked, "signIn closure should be invoked when both fields are filled")
    }

    func test_attemptSignIn_doesNotInvokeClosureWhenDisabled() {
        var closureInvoked = false
        let sut = LoginViewModel(signIn: { closureInvoked = true })
        // username and password remain empty

        sut.attemptSignIn()

        XCTAssertFalse(closureInvoked, "signIn closure should NOT be invoked when fields are empty")
    }
}
