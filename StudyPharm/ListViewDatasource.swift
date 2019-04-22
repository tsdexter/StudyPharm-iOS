    //
//  ListViewDatasource.swift
//  StudyPharm
//
//  Created by Thomas Dexter on 2019-04-21.
//  Copyright © 2019 Thomas Dexter. All rights reserved.
//

import Foundation
import UIKit

class ListViewDatasource: NSObject, UITableViewDataSource {
    var list = [Module]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(ModuleListCell.self), for: indexPath) as! ModuleListCell
        
        cell.moduleItem = list[indexPath.row]
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let item = list[indexPath.row]
//        let detailView: ResourceViewController = ResourceViewController(item: item)
//        tableView..present(detailView, animated: false, completion: nil)
//    }
}
