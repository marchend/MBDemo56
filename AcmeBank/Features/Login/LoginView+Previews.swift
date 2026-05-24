import SwiftUI

#Preview("Default — Empty Fields") {
    LoginView(viewModel: LoginViewModel())
}

#Preview("Filled Fields") {
    let vm = LoginViewModel()
    vm.username = "john.doe@acmebank.com"
    vm.password = "s3cr3tP@ss"
    return LoginView(viewModel: vm)
}

#Preview("Dark Mode") {
    LoginView(viewModel: LoginViewModel())
        .preferredColorScheme(.dark)
}

#Preview("Large Accessibility Text") {
    LoginView(viewModel: LoginViewModel())
        .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
}
