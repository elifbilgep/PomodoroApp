//
//  UserDeafultsManager.swift
//  PomodoroApp
//
//  Created by Elif Parlak on 4.02.2024.
//

import Foundation

class UserDefaultManager: NSObject {
    static let shared = UserDefaultManager()
    private let userDefaults: UserDefaults?
    
    private override init() {
        self.userDefaults = UserDefaults.standard
    }
    
    func remove(for key: UserDefaultsKey) {
        self.userDefaults?.removeObject(forKey: key.value)
        self.userDefaults?.synchronize()
    }
    
    func set<T>(_ obj: T, for key: UserDefaultsKey) {
        self.userDefaults?.set(obj, forKey: key.value)
        self.userDefaults?.synchronize()
    }
    
    func get<T>(for key: UserDefaultsKey) -> T? {
        let result = self.userDefaults?.object(forKey: key.value) as? T
        return result
    }
    
    func object(for key: UserDefaultsKey) -> Any? {
        let result = self.userDefaults?.object(forKey: key.value)
        return result
    }
    
    static func purge() {
        let keys = UserDefaultsKey.allCases
        keys.forEach {
            UserDefaultManager.shared.remove(for: $0)
        }
    }
    
}

enum UserDefaultsKey: String, CaseIterable {
    case currentTaskId = "currentTaskId"
    case currentTimeValue = "currentTimeValue"
    case currentTimerState = "currentTimerState"
    
    var value: String {
        return self.rawValue
    }
}
