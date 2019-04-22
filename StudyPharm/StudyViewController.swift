//
//  StudyViewController.swift
//  StudyPharm
//
//  Created by Thomas Dexter on 2019-04-22.
//  Copyright © 2019 Thomas Dexter. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore

class StudyViewController: UIViewController {
    let db = Firestore.firestore()
    private let dataSource = ListViewDatasource()
    var list = [Module]()
    
    @IBOutlet weak var moduleLabel: UILabel!
    @IBOutlet weak var moduleTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // todo: addviews
        updateViews()
        view.needsUpdateConstraints()
        
        // add data
        getModules()
    }
    
    private func updateViews() {
        
         // table
        moduleTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        moduleTableView.tableFooterView = UIView(frame: .zero)
        moduleTableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 40, right: 0)
        moduleTableView.dataSource = self
        moduleTableView.delegate = self
        moduleTableView.register(ModuleListCell.self, forCellReuseIdentifier: NSStringFromClass(ModuleListCell.self))
        
    }
    
    private func getModules() {
        print("loading modules")
        db.collection("modules")
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                print("loaded modules")
                let modules = documents.map { Module(name: "\($0["name"]!)") }
                self.list = modules
                self.moduleTableView.reloadData()
        }
    }
    
    override func updateViewConstraints() {
        let margins = view.layoutMarginsGuide
        
        super.updateViewConstraints()
    }
}

extension StudyViewController: UITableViewDelegate {
    
}

extension StudyViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(ModuleListCell.self), for: indexPath) as! ModuleListCell
        
        cell.moduleItem = self.list[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didselectrow")
        let item = list[indexPath.row]
        let detailView: ResourceViewController = ResourceViewController(item: item)
        self.showDetailViewController(detailView, sender: nil)
//        self.present(detailView, animated: false, completion: nil)
    }
}
