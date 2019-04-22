//
//  ModulesTableViewController.swift
//  StudyPharm
//
//  Created by Thomas Dexter on 2019-04-21.
//  Copyright © 2019 Thomas Dexter. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore

class ModulesTableViewController: UITableViewController {
    let db = Firestore.firestore()
    private let dataSource = ListViewDatasource()
    
    @IBOutlet weak var modulesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = dataSource
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        modulesLabel.translatesAutoresizingMaskIntoConstraints = false
        modulesLabel.text = "Modules"
        
        render()
        
        view.setNeedsUpdateConstraints()
    }
    
    private func render() {
        print("loading modules")
        db.collection("modules")
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                print("loaded modules")
                let modules = documents.map { "\($0["name"]!)" }
                //self.dataSource.list = modules
                self.tableView.reloadData()
        }
    }
    
    override func updateViewConstraints() {
        let margins = view.layoutMarginsGuide
        
        print("updating contraints")
        
        modulesLabel.topAnchor.constraint(equalTo: tableView.topAnchor).isActive = true
        modulesLabel.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        
        super.updateViewConstraints()
    }
}
