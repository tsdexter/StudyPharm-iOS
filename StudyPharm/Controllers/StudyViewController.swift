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
    
    // update views/layouts
    private func updateViews() {
        // change status bar colour
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.init(red: 0.0/255, green: 75.0/255, blue: 135.0/255, alpha: 1)
        
        view.addSubview(userBarView)
        
         // table
        moduleTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        moduleTableView.tableFooterView = UIView(frame: .zero)
        moduleTableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 40, right: 0)
        moduleTableView.dataSource = self
        moduleTableView.delegate = self
        moduleTableView.register(ModuleListCell.self, forCellReuseIdentifier: NSStringFromClass(ModuleListCell.self))
        
    }
    
    // get modules from firebase and put into table
    private func getModules() {
        print("loading modules")
        db.collection("modules")
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                print("loaded modules")
                let modules = documents.map {
                    Module(
                        id: $0.documentID,
                        name: "\($0["name"]!)"
                    )
                }
                self.list = modules
                self.moduleTableView.reloadData()
        }
    }
    
    // create views
    lazy var userBarView: UserBarView! = {
        let view = UserBarView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // layout views
    override func updateViewConstraints() {
        let margins = view.layoutMarginsGuide
        
        userBarView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        userBarView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        userBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        userBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        userBarView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        super.updateViewConstraints()
    }
}

// extend for table
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
        let detailView: ResourceListViewController = ResourceListViewController(item: item)
        self.present(detailView, animated: false, completion: nil)
    }
}
