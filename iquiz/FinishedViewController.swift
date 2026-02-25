//
//  FinishedViewController.swift
//  iquiz
//
//  Created by Christian James Dizon Correa on 2/24/26.
//

import UIKit

final class FinishedViewController: UIViewController {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!

    @IBOutlet weak var NextButton: UIButton!
    var session: QuizSession!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = session.quiz.title
        render()
    }

    private func render() {
        let score = session.correctCount
        let total = session.totalQuestions
        scoreLabel.text = "\(score) of \(total) correct"

        let pct = Double(score) / Double(total)
        if pct == 1.0 {
            messageLabel.text = "Perfect!"
        } else if pct >= 0.7 {
            messageLabel.text = "Almost!"
        } else {
            messageLabel.text = "Keep trying!"
        }
    }

    @IBAction func nextPressed(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
}
