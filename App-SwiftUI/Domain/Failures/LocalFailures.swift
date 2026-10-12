import Foundation

//local
struct ExistingUserFailure: Error {
    let error: String
    init(error: String = "") { self.error = error }
}

struct GetLocalStorageFailure: Error {
    let error: String
    init(error: String = "") { self.error = error }
}

struct RemoveLocalStorageFailure: Error {
    let error: String
    init(error: String = "") { self.error = error }
}

struct SetLocalStorageFailure: Error {
    let error: String
    init(error: String = "") { self.error = error }
}

//theme
struct GetThemeFailure: Error {
    let error: String
    init(error: String = "") { self.error = error }
}

struct UpdateThemeFailure: Error {
    let error: String
    init(error: String = "") { self.error = error }
}
