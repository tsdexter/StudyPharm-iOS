//
//  ResourceViewController.swift
//  StudyPharm
//
//  Created by Thomas Dexter on 2019-04-22.
//  Copyright © 2019 Thomas Dexter. All rights reserved.
//

import Foundation
import UIKit
import MarkdownView
import SafariServices

class ResourceViewController: UIViewController {
    
    var item: Resource?
    
    init(item: Resource?) {
        self.item = item
        super.init(nibName: nil, bundle: nil);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Cannot be created from storyboard")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add values to views
        updateViews();
        
        view.setNeedsUpdateConstraints()
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
    
    lazy var markdownView: MarkdownView! = {
        let view = MarkdownView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.load(markdown: item!.content.replacingOccurrences(of: "\\n", with: "\n"))
        
        // called when user touch link
        view.onTouchLink = { [weak self] request in
            guard let url = request.url else { return false }
            
            if url.scheme == "file" {
                return false
            } else if url.scheme == "https" || url.scheme == "http" {
                let safari = SFSafariViewController(url: url)
                self?.present(safari, animated: true)
                return false
            } else {
                return false
            }
        }
        
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
    
    // go back to the previous view
    @objc func onBackClicked() {
        self.dismiss(animated: false, completion: nil)
    }
    
    // add the item data to the views
    func updateViews() {
        view.backgroundColor = .white
        view.addSubview(markdownView)
        view.addSubview(titleLabel)
        view.addSubview(backButton)
    }
    
    override func updateViewConstraints() {
        let margins = view.layoutMarginsGuide
        
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        markdownView.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 60).isActive = true
        markdownView.bottomAnchor.constraint(equalTo: backButton.topAnchor, constant: -30).isActive = true
        markdownView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        markdownView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        backButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        super.updateViewConstraints()
    }
}
