//
//  QuizService.swift
//  iquiz
//
//  Created by Christian James Dizon Correa on 2/25/26.
//

import Foundation

enum QuizServiceError: Error {
    case badURL
    case badStatus(Int)
    case decoding(Error)
}

final class QuizService {
    func fetchQuizzes(from urlString: String, completion: @escaping (Result<[Quiz], Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(QuizServiceError.badURL))
            return
        }

        let req = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 15)

        URLSession.shared.dataTask(with: req) { data, response, error in
            if let error { completion(.failure(error)); return }

            if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
                completion(.failure(QuizServiceError.badStatus(http.statusCode)))
                return
            }

            do {
                let decoded = try JSONDecoder().decode([QuizDTO].self, from: data ?? Data())
                let quizzes = decoded.map { $0.toQuiz() }
                completion(.success(quizzes))
            } catch {
                completion(.failure(QuizServiceError.decoding(error)))
            }
        }.resume()
    }
}
