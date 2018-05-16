//
//  LinksTableDataSource.swift
//  PingMeApp
//
//  Created by Mesrop Kareyan on 5/16/18.
//  Copyright © 2018 Mesrop Kareyan. All rights reserved.
//

import UIKit

class LinksTableDataSource: NSObject, UITableViewDataSource {
    
    var linkStore: LinksStore!
    
    init(with store: LinksStore) {
        self.linkStore = store
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return linkStore.links.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LinkTableViewCell") as! LinkTableViewCell
        let link = linkStore.links[indexPath.row]
        cell.configure(for: link)
        return cell
    }
    
    
}
