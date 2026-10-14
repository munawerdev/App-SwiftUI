import Foundation
import Observation

@MainActor
@Observable
final class Router {

    var path: [Route] = []

    func push(_ route: Route) {
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path.removeAll()
    }

    func pop(to route: Route) {
        guard let index = path.lastIndex(of: route) else {
            return
        }

        // Keep the selected route in the stack.
        path.removeLast(path.count - index - 1)
    }

    func pop(count: Int) {
        guard count > 0 else { return }
        path.removeLast(min(count, path.count))
    }
}
