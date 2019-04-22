//
//  ResourceListCell.swift
//  StudyPharm
//
//  Created by Thomas Dexter on 2019-04-22.
//  Copyright © 2019 Thomas Dexter. All rights reserved.
//

import Foundation
import UIKit

class ResourceListCell: UITableViewCell {
    var resourceItem: Resource? {
        didSet {
            if let resource = resourceItem {
                titleLabel.text = resource.name
                setNeedsLayout()
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.setNeedsUpdateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Cannot be created from storyboard")
    }
    
    lazy var titleLabel: UILabel! = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .black
        return view
    }()
    
    override func updateConstraints() {
        let margins = contentView.layoutMarginsGuide
        
        titleLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 0).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 0).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: 0).isActive = true
        super.updateConstraints()
    }
}
