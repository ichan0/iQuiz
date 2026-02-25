//
//  QuestionViewController.swift
//  iquiz
//
//  Created by Christian James Dizon Correa on 2/24/26.
//

import UIKit

final class QuestionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var submitButton: UIButton!

    var session: QuizSession!

    private var selectedIndex: Int? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        guard session != nil else {
            assertionFailure("QuestionViewController.session was not set")
            return
        }
        title = session.quiz.title
        tableView.dataSource = self
        tableView.delegate = self
        submitButton.isEnabled = false
        render()
    }

    private func render() {
        let q = session.currentQuestion
        questionLabel.text = q.text
        selectedIndex = nil
        submitButton.isEnabled = false
        tableView.reloadData()
    }

    // MARK: - Table

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        session.currentQuestion.answers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell")
            ?? UITableViewCell(style: .default, reuseIdentifier: "AnswerCell")
        cell.textLabel?.text = session.currentQuestion.answers[indexPath.row]
        cell.accessoryType = (indexPath.row == selectedIndex) ? .checkmark : .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        submitButton.isEnabled = true
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Submit

    @IBAction func submitPressed(_ sender: Any) {
        guard let selectedIndex else { return }
        performSegue(withIdentifier: "ShowAnswer", sender: selectedIndex)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowAnswer",
           let selected = sender as? Int,
           let dest = segue.destination as? AnswerViewController {

            let isCorrect = session.submitAnswer(selectedIndex: selected)

            dest.session = session
            dest.wasCorrect = isCorrect
        }
    }
}
