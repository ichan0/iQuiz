//
//  UITableViewController.swift
//  iquiz
//
//  Created by Christian James Dizon Correa on 2/17/26.
//

import UIKit

struct QuizTopic {
    let title: String
    let description: String
    let icon: String
}

final class QuizListViewController: UITableViewController {
    private let topics = [
        QuizTopic(title: "Mathematics",
                  description: "Mathematics quiz",
                  icon: "math"),
        QuizTopic(title: "Marvel Super Heroes",
                  description: "Marvel superhero quiz",
                  icon: "marvel"),
        QuizTopic(title: "Science",
                 description: "Science quiz",
                  icon: "science")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "iQuiz"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        topics.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopicCell", for: indexPath)
        let topic = topics[indexPath.row]
        cell.textLabel?.text = topic.title
        cell.detailTextLabel?.text = topic.description
        cell.imageView?.image = UIImage(systemName: topic.icon)
        return cell
    }
    
    @IBAction func settingsPressed(_ sender: Any) {
        let alert = UIAlertController(
            title: nil,
            message: "Settings go here",
            preferredStyle: .alert
            )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
}
