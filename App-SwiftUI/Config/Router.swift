import SwiftUI
import Observation

@Observable
final class Router {
    var path: [Route] = []

    func push(_ route: Route) { path.append(route) }
    func pop()                { _ = path.popLast() }
    func popToRoot()          { path.removeAll() }
}
