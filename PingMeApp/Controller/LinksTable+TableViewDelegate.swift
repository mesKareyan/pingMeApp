//
//  LinksTable+TableViewDelegate.swift
//  PingMeApp
//
//  Created by Mesrop Kareyan on 5/16/18.
//  Copyright © 2018 Mesrop Kareyan. All rights reserved.
//

import UIKit

//MARK: - Table view
extension LinksTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchingActive ? filteredLinks.count : linkStore.links.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LinkTableViewCell") as! LinkTableViewCell
        let link = isSearchingActive ?
            filteredLinks[indexPath.row] : linkStore.links[indexPath.row]
        cell.configure(for: link)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! LinkTableViewCell
        cell.updateCell()
    }
    
    //MARK: Deleting
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            let link = isSearchingActive ?
                filteredLinks[indexPath.row] : linkStore.links[indexPath.row]
            showDeleteAlert(for: link, atIndex: indexPath.row)
        }
    }
    
    func showDeleteAlert(for link: Link, atIndex: Int) {
        let alert = UIAlertController(title: "Delete link for list",
                                      message: "Are you sure?",
                                      preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                //delete the link
                if self.isSearchingActive {
                    self.filteredLinks.remove(at: atIndex)
                    self.tableView.deleteRows(at: [IndexPath(row: atIndex, section: 0)], with: .automatic)
                    self.linkStore.remove(link: link)
                } else {
                    self.linkStore.remove(link: link)
                    self.tableView.deleteRows(at: [IndexPath(row: atIndex, section: 0)], with: .automatic)
                }
            })
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
        
    }
    
}

