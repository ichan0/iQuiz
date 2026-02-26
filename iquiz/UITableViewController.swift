//
//  UITableViewController.swift
//  iquiz
//
//  Created by Christian James Dizon Correa on 2/17/26.
//

import UIKit

//struct QuizTopic {
//    let title: String
//    let description: String
//    let icon: String
//}

final class QuizListViewController: UITableViewController {
    
    private let service = QuizService()

    // Quizzes
    private let mathQuiz = Quiz(title: "Mathematics", questions: [
        Question(text: "2 + 2 = ?", answers: ["3","4","5"], correctIndex: 1),
        Question(text: "5 × 3 = ?", answers: ["8","15","10"], correctIndex: 1)
    ])

    private let marvelQuiz = Quiz(title: "Marvel Super Heroes", questions: [
        Question(text: "Who is Iron Man?", answers: ["Bruce Wayne","Tony Stark","Peter Parker"], correctIndex: 1),
        Question(text: "Captain America's shield is made of…", answers: ["Vibranium","Adamantium","Steel"], correctIndex: 0)
    ])

    
    private let scienceQuiz = Quiz(title: "Science", questions: [
        Question(text: "Water's chemical formula is…", answers: ["CO2","H2O","O2"], correctIndex: 1),
        Question(text: "Earth orbits the…", answers: ["Moon","Mars","Sun"], correctIndex: 2)
    ])

        // Topics (ONE array)
//    private var topics: [QuizTopic] = [
//        QuizTopic(title: "Mathematics", description: "Mathematics quiz", icon: "math", quiz: mathQuiz),
//        QuizTopic(title: "Marvel Super Heroes", description: "Marvel superhero quiz", icon: "marvel", quiz: marvelQuiz),
//        QuizTopic(title: "Science", description: "Science quiz", icon: "science", quiz: scienceQuiz)
//    ]
    
    private var topics: [QuizTopic] = []
    
//    private let topics = [
//        QuizTopic(title: "Mathematics",
//                  description: "Mathematics quiz",
//                  icon: "math"),
//        QuizTopic(title: "Marvel Super Heroes",
//                  description: "Marvel superhero quiz",
//                  icon: "marvel"),
//        QuizTopic(title: "Science",
//                 description: "Science quiz",
//                  icon: "science")
//    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "iQuiz"
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        topics = [
                QuizTopic(title: "Mathematics", description: "Mathematics quiz", icon: "math", quiz: mathQuiz),
                QuizTopic(title: "Marvel Super Heroes", description: "Marvel superhero quiz", icon: "marvel", quiz: marvelQuiz),
                QuizTopic(title: "Science", description: "Science quiz", icon: "science", quiz: scienceQuiz)
            ]

    }

   
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        topics.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopicCell", for: indexPath)
        let topic = topics[indexPath.row]
        cell.textLabel?.text = topic.title
        cell.detailTextLabel?.text = topic.description
        cell.imageView?.image = UIImage(named: topic.icon)
        return cell
    }
    
    
    @IBAction func settingsPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Settings", message: nil, preferredStyle: .alert)

        alert.addTextField { tf in
            tf.placeholder = "Quiz URL"
            tf.text = AppSettings.quizSourceURL
            tf.keyboardType = .URL
            tf.autocapitalizationType = .none
            tf.autocorrectionType = .no
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { _ in
            let url = alert.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            if !url.isEmpty { AppSettings.quizSourceURL = url }
        }))

        alert.addAction(UIAlertAction(title: "Check Now", style: .default, handler: { [weak self] _ in
            let url = alert.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? AppSettings.quizSourceURL
            if !url.isEmpty { AppSettings.quizSourceURL = url }
            self?.checkNow()
        }))

        present(alert, animated: true)
    }
        
//        let alert = UIAlertController(
//            title: nil,
//            message: "Settings go here",
//            preferredStyle: .alert
//            )
//        alert.addAction(UIAlertAction(title: "OK", style: .default))
//        present(alert, animated: true)
//    }
    

    private func checkNow() {
        let url = AppSettings.quizSourceURL

        service.fetchQuizzes(from: url) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }

                switch result {
                case .success(let quizzes):
                    self.topics = quizzes.map { quiz in
                        QuizTopic(
                            title: quiz.title,
                            description: "Loaded from network",
                            icon: "science",
                            quiz: quiz
                        )
                    }
                    self.tableView.reloadData()

                case .failure:
                    self.showNetworkError()
                }
            }
        }
    }
    
    // Part 2: tap topic -> first question
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "ShowQuestion", sender: topics[indexPath.row])
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowQuestion",
            let topic = sender as? QuizTopic,
            let dest = segue.destination as? QuestionViewController {
            dest.session = QuizSession(quiz: topic.quiz)
        }
    }
    
    private func showNetworkError(_ error: Error? = nil) {
        let message: String
        if NetworkMonitor.shared.isOnline == false {
            message = "Network is not available. Please connect to the internet and try again."
        } else {
            message = "Could not download quizzes. Check the URL and try again."
        }

        let alert = UIAlertController(title: "Network Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
}
