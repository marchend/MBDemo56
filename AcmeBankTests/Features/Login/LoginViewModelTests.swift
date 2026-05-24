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

    // MARK: - attemptSignIn closure signature

    func test_attemptSignIn_invokesClosureWithTypedCredentialsAndKeepSignedIn() {
        var receivedUsername: String?
        var receivedPassword: String?
        var receivedKeepSignedIn: Bool?
        let sut = LoginViewModel { username, password, keepSignedIn in
            receivedUsername = username
            receivedPassword = password
            receivedKeepSignedIn = keepSignedIn
        }
        sut.username = "user@acmebank.com"
        sut.password = "s3cr3tP@ss"
        sut.keepSignedIn = true

        sut.attemptSignIn()

        XCTAssertEqual(receivedUsername, "user@acmebank.com")
        XCTAssertEqual(receivedPassword, "s3cr3tP@ss")
        XCTAssertEqual(receivedKeepSignedIn, true)
    }

    func test_attemptSignIn_passesKeepSignedInFalseByDefault() {
        var receivedKeepSignedIn: Bool?
        let sut = LoginViewModel { _, _, keepSignedIn in
            receivedKeepSignedIn = keepSignedIn
        }
        sut.username = "user@acmebank.com"
        sut.password = "s3cr3tP@ss"

        sut.attemptSignIn()

        XCTAssertEqual(receivedKeepSignedIn, false,
                       "keepSignedIn should default to false")
    }

    func test_attemptSignIn_doesNotInvokeClosureWhenDisabled() {
        var closureInvoked = false
        let sut = LoginViewModel { _, _, _ in closureInvoked = true }
        // username and password remain empty

        sut.attemptSignIn()

        XCTAssertFalse(closureInvoked,
                       "onSignIn closure should NOT be invoked when fields are empty")
    }

    // MARK: - keepSignedIn

    func test_keepSignedIn_defaultsToFalse() {
        let sut = LoginViewModel()
        XCTAssertFalse(sut.keepSignedIn)
    }

    func test_keepSignedIn_canBeToggled() {
        let sut = LoginViewModel()
        sut.keepSignedIn = true
        XCTAssertTrue(sut.keepSignedIn)
        sut.keepSignedIn = false
        XCTAssertFalse(sut.keepSignedIn)
    }

    // MARK: - errorMessage

    func test_errorMessage_defaultsToNil() {
        let sut = LoginViewModel()
        XCTAssertNil(sut.errorMessage)
    }

    func test_errorMessage_roundTripsThroughPublishedProperty() {
        let sut = LoginViewModel()
        sut.errorMessage = "Invalid username or password."
        XCTAssertEqual(sut.errorMessage, "Invalid username or password.")
        sut.errorMessage = nil
        XCTAssertNil(sut.errorMessage)
    }
}
