import Foundation
import Observation

/// Feature state and presentation logic for the sign-in screen.
/// Keep this type focused on UI state; authentication rules belong in a use case
/// once this app has a real authentication service.
@Observable
final class AuthViewModel {
    var email = ""
    var password = ""
}
