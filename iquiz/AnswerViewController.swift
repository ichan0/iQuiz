//
//  AnswerViewController.swift
//  iquiz
//
//  Created by Christian James Dizon Correa on 2/24/26.
//

import UIKit

final class AnswerViewController: UIViewController {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var correctAnswerLabel: UILabel!
    
    @IBOutlet weak var NextButton: UIButton!
    
    var session: QuizSession!
    var wasCorrect: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        title = session.quiz.title
        render()
    }

    private func render() {
        let q = session.currentQuestion
        questionLabel.text = q.text
        resultLabel.text = wasCorrect ? "Correct!" : "Incorrect."
        correctAnswerLabel.text = "Correct answer: \(q.answers[q.correctIndex])"
    }

    @IBAction func nextPressed(_ sender: Any) {
        if session.isFinished {
            let vc = storyboard?.instantiateViewController(withIdentifier: "FinishedViewController") as! FinishedViewController
            vc.session = session
            navigationController?.pushViewController(vc, animated: true)
        } else {
            session.advance()
            // Push a fresh QuestionVC
            let vc = storyboard?.instantiateViewController(withIdentifier: "QuestionViewController") as! QuestionViewController
            vc.session = session
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
