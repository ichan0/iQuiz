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
            guard let url = URL(string: urlString) else { completion(.failure(NSError())); return }

            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error { completion(.failure(error)); return }
                guard let data = data else { completion(.failure(NSError())); return }

                do {
                    // decode
                    let decoded = try JSONDecoder().decode([QuizDTO].self, from: data)
                    let quizzes = decoded.map { $0.toQuiz() }

                    // cache raw JSON
                    try? QuizCache.save(jsonData: data)

                    completion(.success(quizzes))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }
    
}

