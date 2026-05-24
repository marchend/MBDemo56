import XCTest

final class LoginViewUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments += ["-UITestMode", "YES"]
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    /// Login screen is the first thing the user sees on launch.
    func testLoginScreenAppearsOnLaunch() {
        let usernameField = app.textFields["login_username_field"]
        XCTAssertTrue(
            usernameField.waitForExistence(timeout: 5),
            "Username text field should be visible when the app launches"
        )
    }

    /// Sign In button should be disabled while both fields are empty.
    func testSignInButtonDisabledOnLaunch() {
        let signInButton = app.buttons["login_sign_in_button"]
        XCTAssertTrue(
            signInButton.waitForExistence(timeout: 5),
            "Sign In button should exist on launch"
        )
        XCTAssertFalse(
            signInButton.isEnabled,
            "Sign In button should be disabled when both fields are empty"
        )
    }

    /// Sign In button becomes enabled once both fields contain text.
    func testSignInButtonEnabledAfterInput() {
        let usernameField = app.textFields["login_username_field"]
        let passwordField = app.secureTextFields["login_password_field"]
        let signInButton = app.buttons["login_sign_in_button"]

        XCTAssertTrue(usernameField.waitForExistence(timeout: 5))
        usernameField.tap()
        usernameField.typeText("user@acmebank.com")

        XCTAssertTrue(passwordField.waitForExistence(timeout: 5))
        passwordField.tap()
        passwordField.typeText("s3cr3tP@ss")

        XCTAssertTrue(
            signInButton.isEnabled,
            "Sign In button should be enabled when both username and password are filled"
        )
    }

    /// Tapping Sign In with valid credentials should not crash or show an error alert.
    func testSignInButtonTappable() {
        let usernameField = app.textFields["login_username_field"]
        let passwordField = app.secureTextFields["login_password_field"]
        let signInButton = app.buttons["login_sign_in_button"]

        XCTAssertTrue(usernameField.waitForExistence(timeout: 5))
        usernameField.tap()
        usernameField.typeText("user@acmebank.com")

        XCTAssertTrue(passwordField.waitForExistence(timeout: 5))
        passwordField.tap()
        passwordField.typeText("s3cr3tP@ss")

        XCTAssertTrue(signInButton.isEnabled)
        signInButton.tap()

        // Verify no error alert appeared after tap (stub signIn closure is a no-op)
        let errorAlert = app.alerts.firstMatch
        XCTAssertFalse(
            errorAlert.waitForExistence(timeout: 2),
            "No error alert should appear after tapping Sign In with the stub closure"
        )
    }
}
