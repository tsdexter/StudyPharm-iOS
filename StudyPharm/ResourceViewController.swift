//
//  ResourceViewController.swift
//  StudyPharm
//
//  Created by Thomas Dexter on 2019-04-22.
//  Copyright © 2019 Thomas Dexter. All rights reserved.
//

import Foundation
import UIKit

class ResourceViewController: UIViewController {
    
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
        
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.needsUpdateConstraints()
    }
    
    lazy var titleLabel: UILabel! = {
        let view = UILabel()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = item!.name
        
        return view
    }()
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
    }
}
