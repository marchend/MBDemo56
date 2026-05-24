import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                // Logo
                Image("AcmeBankLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .padding(.bottom, 24)

                // Title
                Text("Acme Bank")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 4)

                // Subtitle
                Text("Sign in to your account")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 40)

                // Username field
                TextField("name@acmebank.com", text: $viewModel.username)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                    .keyboardType(.emailAddress)
                    .textContentType(.username)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.secondarySystemBackground))
                    )
                    .padding(.horizontal, 24)
                    .padding(.bottom, 16)
                    .accessibilityIdentifier("login_username_field")

                // Password field with reveal toggle
                HStack {
                    if viewModel.isPasswordRevealed {
                        TextField("Password", text: $viewModel.password)
                            .textContentType(.password)
                            .autocapitalization(.none)
                            .autocorrectionDisabled()
                            .accessibilityIdentifier("login_password_field")
                    } else {
                        SecureField("Password", text: $viewModel.password)
                            .textContentType(.password)
                            .accessibilityIdentifier("login_password_field")
                    }

                    Button(action: { viewModel.isPasswordRevealed.toggle() }) {
                        Image(systemName: viewModel.isPasswordRevealed ? "eye.slash" : "eye")
                            .foregroundStyle(.secondary)
                    }
                    .accessibilityLabel(viewModel.isPasswordRevealed ? "Hide password" : "Show password")
                    .accessibilityIdentifier("login_password_reveal_toggle")
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.secondarySystemBackground))
                )
                .padding(.horizontal, 24)
                .padding(.bottom, 16)

                // "Keep me signed in" checkbox
                Toggle(isOn: $viewModel.keepMeSignedIn) {
                    Text("Keep me signed in")
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                }
                .toggleStyle(.checkmark)
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
                .accessibilityIdentifier("login_keep_signed_in_toggle")

                // Sign In button
                Button(action: viewModel.attemptSignIn) {
                    Text("Sign In")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(viewModel.isSignInEnabled
                                      ? Color.accentColor
                                      : Color.accentColor.opacity(0.4))
                        )
                }
                .disabled(!viewModel.isSignInEnabled)
                .padding(.horizontal, 24)
                .accessibilityIdentifier("login_sign_in_button")

                // "Need help?" link
                Button(action: { viewModel.isNeedHelpPresented = true }) {
                    Text("Need help?")
                        .font(.footnote)
                        .foregroundStyle(.accentColor)
                        .padding(.top, 16)
                }
                .accessibilityIdentifier("login_need_help_button")
                .sheet(isPresented: $viewModel.isNeedHelpPresented) {
                    NeedHelpView()
                }

                Spacer()
            }
        }
    }
}
