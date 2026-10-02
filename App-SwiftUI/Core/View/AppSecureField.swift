import SwiftUI

struct AppSecureField: View {
    let title: String
    @Binding var text: String
    var contentType: UITextContentType? = .password

    var body: some View {
        SecureField(title, text: $text)
            .textContentType(contentType)
            .textInputAutocapitalization(.never)
            .padding(.horizontal, 18)
            .frame(minHeight: 54)
            .background(.white, in: RoundedRectangle(cornerRadius: 14))
            .overlay {
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            }
    }
}
