//
//  QuizSession.swift
//  iquiz
//
//  Created by Christian James Dizon Correa on 2/24/26.
//

import Foundation

final class QuizSession {
    let quiz: Quiz
    
    private(set) var index: Int = 0
    private(set) var correctCount: Int = 0
    private(set) var lastSelectedIndex: Int? = nil
    
    init(quiz: Quiz) {
        self.quiz = quiz
    }
    
    var currentQuestion: Question { quiz.questions[index] }
    var totalQuestions: Int { quiz.questions.count }
    var isFinished: Bool { index >= quiz.questions.count - 1 }
    
    func submitAnswer(selectedIndex: Int) -> Bool {
        lastSelectedIndex = selectedIndex
        let isCorrect = (selectedIndex == currentQuestion.correctIndex)
        if isCorrect { correctCount += 1 }
        return isCorrect
    }
    
    func advance() {
        index += 1
    }
}
