//
//  QuizCache.swift
//  iquiz
//
//  Created by Christian James Dizon Correa on 2/25/26.
//

import Foundation

enum QuizCache {
    private static let fileName = "quizzes.json"

    private static var fileURL: URL {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return dir.appendingPathComponent(fileName)
    }

    static func save(jsonData: Data) throws {
        try jsonData.write(to: fileURL, options: [.atomic])
    }

    static func load() throws -> Data {
        try Data(contentsOf: fileURL)
    }

    static func exists() -> Bool {
        FileManager.default.fileExists(atPath: fileURL.path)
    }
}
