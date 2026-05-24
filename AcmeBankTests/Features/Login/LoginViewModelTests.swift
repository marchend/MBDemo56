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

    // MARK: - isPasswordRevealed

    func test_isPasswordRevealed_defaultsFalse() {
        let sut = LoginViewModel()
        XCTAssertFalse(sut.isPasswordRevealed, "Password should be hidden by default")
    }

    func test_isPasswordRevealed_togglesTrue() {
        let sut = LoginViewModel()
        sut.isPasswordRevealed = true
        XCTAssertTrue(sut.isPasswordRevealed)
    }

    // MARK: - keepMeSignedIn

    func test_keepMeSignedIn_defaultsFalse() {
        let sut = LoginViewModel()
        XCTAssertFalse(sut.keepMeSignedIn, "\"Keep me signed in\" should be unchecked by default")
    }

    func test_keepMeSignedIn_canBeSetTrue() {
        let sut = LoginViewModel()
        sut.keepMeSignedIn = true
        XCTAssertTrue(sut.keepMeSignedIn)
    }

    // MARK: - isNeedHelpPresented

    func test_isNeedHelpPresented_defaultsFalse() {
        let sut = LoginViewModel()
        XCTAssertFalse(sut.isNeedHelpPresented, "\"Need help?\" sheet should not be presented by default")
    }

    func test_isNeedHelpPresented_canBeSetTrue() {
        let sut = LoginViewModel()
        sut.isNeedHelpPresented = true
        XCTAssertTrue(sut.isNeedHelpPresented)
    }
}
