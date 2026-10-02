import Observation
import SwiftUI

@Observable
final class Router {
    var path: [Route] = []

    func push(_ route: Route) { path.append(route) }
    func pop() { _ = path.popLast() }
    func popToRoot() { path.removeAll() }

    /// Go back to a specific screen that is already in the stack.
    func pop(to route: Route) {
        guard let index = path.lastIndex(of: route) else { return }
        path.removeLast(path.count - index - 1)
    }

    /// Go back N screens.
    func pop(count: Int) {
        path.removeLast(min(count, path.count))
    }
}
