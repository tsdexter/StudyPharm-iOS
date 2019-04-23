//
//  MeViewController.swift
//  StudyPharm
//
//  Created by Thomas Dexter on 2019-04-22.
//  Copyright © 2019 Thomas Dexter. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import UIKit
import Charts

class MeViewController: UIViewController {
    // init views and outlets
    @IBOutlet weak var linechartView: LineChartView!
    @IBOutlet weak var clickLabel: UILabel!
    
    // database
    let db = Firestore.firestore()

    // init vars
    var list = [Attempt]()
    var quizzes = [Quiz]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        fillChart()
    }
    
    // update views
    private func updateViews() {
        view.addSubview(tableView)
        view.needsUpdateConstraints()
    }
    
    lazy var tableView: UITableView! = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        view.tableFooterView = UIView(frame: .zero)
        view.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 40, right: 0)
        
        view.dataSource = self
        view.delegate = self
        view.register(AttemptCell.self, forCellReuseIdentifier: NSStringFromClass(AttemptCell.self))
        
        return view
    }()
    
    override func updateViewConstraints() {
        tableView.topAnchor.constraint(equalTo: clickLabel.bottomAnchor, constant: 30).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        super.updateViewConstraints()
    }
    
    // fill chart
    private func fillChart() {
        let user =  Auth.auth().currentUser
        print("loading attampts")
        db.collection("attempts").whereField("user", isEqualTo: user?.uid as Any)
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching attemps: \(error!)")
                    return
                }
                print("loaded attempts")
                let attempts = documents.map {
                    Attempt(
                        id: $0.documentID,
                        module: $0["module"] as! String,
                        quiz: $0["quiz"] as! String,
                        name: $0["name"] as! String,
                        score: $0["score"] as! Int,
                        percent: $0["percent"] as! Double
                    )
                }
                
                let values = (0..<attempts.count).map {(i) -> ChartDataEntry in
                    // add quiz
                    let quiz = Quiz(name: attempts[i].name)
                    for attempt in attempts {
                        if(attempt.name == attempts[i].name) {
                            quiz.addAttempt(attempt: attempt)
                        }
                    }
                    self.quizzes.append(quiz)
                    
                    // add value
                    let val = attempts[i].percent
                    return ChartDataEntry(x: Double(i), y: val)
                }
                
                let set1 = LineChartDataSet(entries: values, label: "All Attempts")
                let data = LineChartData(dataSet: set1)
                self.linechartView.data = data
                self.list = attempts
                self.tableView.reloadData()
        }
    }
}

extension MeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(AttemptCell.self), for: indexPath) as! AttemptCell
        
        cell.attemptItem = list[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = list[indexPath.row]
    }
}

extension MeViewController: UITableViewDelegate {
    
}
