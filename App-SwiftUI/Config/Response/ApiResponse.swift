enum ApiResponse<T> {
    case initial(T)
    case loading
    case completed(T)
    case error(NetworkFailure)

    var status: Status {
        switch self {
        case .initial:   return .initial
        case .loading:   return .loading
        case .completed: return .completed
        case .error:     return .error
        }
    }

    var data: T? {
        if case .completed(let value) = self { return value }
        return nil
    }

    var initialValue: T? {
        if case .initial(let value) = self { return value }
        return nil
    }

    var failure: NetworkFailure? {
        if case .error(let failure) = self { return failure }
        return nil
    }
}
