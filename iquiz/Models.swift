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
