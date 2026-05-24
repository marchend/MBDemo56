import XCTest

final class LoginViewUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments += ["-UITestMode", "YES"]
    }

    override func tearDownWithError() throws {
        app = nil
    }

    /// Login screen is the first thing the user sees on launch.
    func testLoginScreenAppearsOnLaunch() {
        app.launch()

        let usernameField = app.textFields["login_username_field"]
        XCTAssertTrue(
            usernameField.waitForExistence(timeout: 5),
            "Username text field should be visible when the app launches"
        )
    }

    /// Sign In button should be disabled while both fields are empty.
    func testSignInButtonDisabledOnLaunch() {
        app.launch()

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
        app.launch()

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
        app.launch()

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

        // Verify no error alert appeared after tap (stub onSignIn closure is a no-op)
        let errorAlert = app.alerts.firstMatch
        XCTAssertFalse(
            errorAlert.waitForExistence(timeout: 2),
            "No error alert should appear after tapping Sign In with the stub closure"
        )
    }

    // MARK: - Keep me signed in toggle

    /// Toggling "Keep me signed in" flips its bound state.
    func testKeepSignedInToggleFlipsState() {
        app.launch()

        let toggle = app.switches["login_keep_signed_in_toggle"]
        XCTAssertTrue(
            toggle.waitForExistence(timeout: 5),
            "Keep me signed in toggle should be visible on launch"
        )
        // Toggle defaults to off (`0`).
        XCTAssertEqual(toggle.value as? String, "0",
                       "Toggle should default to off")

        toggle.tap()
        XCTAssertEqual(toggle.value as? String, "1",
                       "Toggle should be on after first tap")

        toggle.tap()
        XCTAssertEqual(toggle.value as? String, "0",
                       "Toggle should be off after second tap")
    }

    // MARK: - Error banner

    /// Error banner is hidden when errorMessage is nil (default launch).
    func testErrorBannerHiddenByDefault() {
        app.launch()

        // Wait for the screen to settle.
        XCTAssertTrue(app.textFields["login_username_field"].waitForExistence(timeout: 5))

        let banner = app.staticTexts["login.errorBanner"]
        XCTAssertFalse(
            banner.exists,
            "Error banner should not be visible when errorMessage is nil"
        )
    }

    /// Error banner appears when the app is launched with the UI-test hook
    /// that pre-populates `errorMessage` on the login view model.
    func testErrorBannerVisibleWhenErrorMessageIsSet() {
        app.launchArguments += ["-UITestShowErrorBanner"]
        app.launch()

        let banner = app.staticTexts["login.errorBanner"]
        XCTAssertTrue(
            banner.waitForExistence(timeout: 5),
            "Error banner should be visible when errorMessage is set via the UI-test hook"
        )
    }
}
