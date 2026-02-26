//
//  AppSettings.swift
//  iquiz
//
//  Created by Christian James Dizon Correa on 2/25/26.
//

import Foundation

enum AppSettings {
    private static let urlKey = "quizSourceURL"
    static let defaultURL = "http://tednewardsandbox.site44.com/questions.json"

    static var quizSourceURL: String {
        get { UserDefaults.standard.string(forKey: urlKey) ?? defaultURL }
        set { UserDefaults.standard.set(newValue, forKey: urlKey) }
    }
}

