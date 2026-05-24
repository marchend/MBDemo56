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

                // Welcome headline
                Text("Welcome to AcmeBank")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 40)

                // Username field
                TextField("Username", text: $viewModel.username)
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

                // Password field
                SecureField("Password", text: $viewModel.password)
                    .textContentType(.password)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.secondarySystemBackground))
                    )
                    .padding(.horizontal, 24)
                    .padding(.bottom, 16)
                    .accessibilityIdentifier("login_password_field")

                // Inline error banner — visible only when errorMessage is non-nil.
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.footnote)
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.red)
                        )
                        .padding(.horizontal, 24)
                        .padding(.bottom, 16)
                        .accessibilityIdentifier("login.errorBanner")
                }

                // Keep me signed in toggle
                Toggle("Keep me signed in", isOn: $viewModel.keepSignedIn)
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

                Spacer()
            }
        }
    }
}
