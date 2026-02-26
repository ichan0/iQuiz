//
//  Models.swift
//  iquiz
//
//  Created by Christian James Dizon Correa on 2/24/26.
//

import Foundation


struct QuizTopic {
    let title: String
    let description: String
    let icon: String
    let quiz: Quiz
}

struct Quiz {
    let title: String
    let questions: [Question]
}

struct Question {
    let text: String
    let answers: [String]
    let correctIndex: Int
}

struct QuizDTO: Decodable {
    let title: String
    let desc: String
    let questions: [QuestionDTO]
}

struct QuestionDTO: Decodable {
    let text: String
    let answer: String      // "1", "2", etc. (string in JSON)
    let answers: [String]
}

// Convert DTO → your in-app models
extension QuizDTO {
    func toQuiz() -> Quiz {
        Quiz(
            title: title,
            questions: questions.map { $0.toQuestion() }
        )
    }
}

extension QuestionDTO {
    func toQuestion() -> Question {
        // JSON uses "1" for first answer, so convert to 0-based Int
        let oneBased = Int(answer) ?? 1
        let correctIndex = max(0, min(answers.count - 1, oneBased - 1))
        return Question(text: text, answers: answers, correctIndex: correctIndex)
    }
}
