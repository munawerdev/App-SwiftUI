import SwiftUI

struct AppTextField: View {
    let title: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var contentType: UITextContentType?
    var capitalization: TextInputAutocapitalization = .sentences

    var body: some View {
        TextField(title, text: $text)
            .textInputAutocapitalization(capitalization)
            .keyboardType(keyboardType)
            .textContentType(contentType)
            .padding(.horizontal, 18)
            .frame(minHeight: 54)
            .background(.white, in: RoundedRectangle(cornerRadius: 14))
            .overlay {
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            }
    }
}
