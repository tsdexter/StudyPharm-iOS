//
//  AttemptCell.swift
//  StudyPharm
//
//  Created by Thomas Dexter on 2019-04-22.
//  Copyright © 2019 Thomas Dexter. All rights reserved.
//

import Foundation
import UIKit

class AttemptCell: UITableViewCell {
    var attemptItem: Attempt? {
        didSet {
            if let attempt = attemptItem {
                titleLabel.text = attempt.name
                percentLabel.text = String(format:"%.0f", attempt.percent) + "%"
        
                // highlight percentgge based on grade
                if (attempt.percent > 90) {
                    percentLabel.textColor = .green
                } else if (attempt.percent > 60 && attempt.percent < 80) {
                    percentLabel.textColor = .yellow
                } else {
                    percentLabel.textColor = .red
                }
                setNeedsLayout()
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(percentLabel)
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
    
    lazy var percentLabel: UILabel! = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .black
        view.textAlignment = .right
        return view
    }()
    
    override func updateConstraints() {
        let margins = contentView.layoutMarginsGuide
        
        titleLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 0).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: percentLabel.leadingAnchor, constant: 15).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: 0).isActive = true
        
        percentLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        percentLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: 0).isActive = true
        percentLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        super.updateConstraints()
    }
}

