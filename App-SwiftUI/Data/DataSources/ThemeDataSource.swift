// ThemeDataSources.swift
import Foundation
import Observation

@MainActor
@Observable
final class ThemeDataSources {
    private(set) var isDarkTheme: Bool = false

    func setTheme(_ isDarkTheme: Bool) {
        self.isDarkTheme = isDarkTheme
    }
}
