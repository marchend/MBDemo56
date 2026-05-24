import SwiftUI

/// Modal sheet presented when the user taps "Need help?" on the login screen.
struct NeedHelpView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("If you have forgotten your username or password, please contact Acme Bank support.")
                    .font(.body)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .padding(.top, 32)

                Spacer()
            }
            .navigationTitle("Need help?")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Close") { dismiss() }
                        .accessibilityIdentifier("need_help_close_button")
                }
            }
        }
        .accessibilityIdentifier("need_help_sheet")
    }
}
