//
//  ResourceViewController.swift
//  StudyPharm
//
//  Created by Thomas Dexter on 2019-04-22.
//  Copyright © 2019 Thomas Dexter. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore

class ResourceListViewController: UIViewController {
    
    let db = Firestore.firestore()
    var list = [Resource]()
    var item: Module?
    
    init(item: Module?) {
        self.item = item
        
        super.init(nibName: nil, bundle: nil);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Cannot be created from storyboard")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // update colours
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.init(red: 0.0/255, green: 75.0/255, blue: 135.0/255, alpha: 1)
        view.backgroundColor = .white
        
        // add views
        view.addSubview(userBarView)
        view.addSubview(titleLabel)
        view.addSubview(resourcesTableView)
        view.addSubview(backButton)
        
        // update layout
        view.needsUpdateConstraints()
        
        // add data
        getResources()
    }
    
    // get resources from firebase and put into table
    private func getResources() {
        print("loading resources for " + item!.id)
        db.collection("resources").whereField("module", isEqualTo: item!.id)
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                print("loaded resources")
                let resources = documents.map {
                    Resource(
                        id: $0.documentID,
                        name: "\($0["name"]!)",
                        module: "\($0["module"]!)",
                        content: "\($0["content"]!)"
                    )
                }
                self.list = resources
                self.resourcesTableView.reloadData()
        }
    }
    
    // init views
    lazy var titleLabel: UILabel! = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .center
        view.font = view.font.withSize(24)
        view.text = item!.name
        
        return view
    }()
    
    lazy var userBarView: UserBarView! = {
        let view = UserBarView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var resourcesTableView: UITableView! = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        view.tableFooterView = UIView(frame: .zero)
        view.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 40, right: 0)
        
        view.dataSource = self
        view.delegate = self
        view.register(ResourceListCell.self, forCellReuseIdentifier: NSStringFromClass(ResourceListCell.self))
        
        return view
    }()
    
    lazy var backButton: UIButton! = {
        let view = UIButton()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.setTitle("Back", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.backgroundColor = UIColor.init(red: 0.0/255, green: 75.0/255, blue: 135.0/255, alpha: 1)
        view.addTarget(self, action: #selector(onBackClicked), for: .touchDown)
        
        return view
    }()
    
    // handle events
    @objc private func onBackClicked() {
        dismiss(animated: true, completion: nil)
    }
    
    // update layout
    override func updateViewConstraints() {
        let margins = view.layoutMarginsGuide
        
        userBarView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        userBarView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        userBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        userBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        userBarView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: userBarView.bottomAnchor, constant: 60).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        backButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        resourcesTableView.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 60).isActive = true
        resourcesTableView.bottomAnchor.constraint(equalTo: backButton.topAnchor, constant: -30).isActive = true
        resourcesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        resourcesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        super.updateViewConstraints()
    }
}

extension UIApplication {
    
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
    
}

extension ResourceListViewController: UITableViewDelegate {
    
}

extension ResourceListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(ResourceListCell.self), for: indexPath) as! ResourceListCell
        
        cell.resourceItem = self.list[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didselectrow")
        let item = list[indexPath.row]
        let detailView: ResourceViewController = ResourceViewController(item: item)
        self.present(detailView, animated: false, completion: nil)
    }
}
