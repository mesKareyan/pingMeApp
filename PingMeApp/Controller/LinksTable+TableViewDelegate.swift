//
//  LinksTable+TableViewDelegate.swift
//  PingMeApp
//
//  Created by Mesrop Kareyan on 5/16/18.
//  Copyright © 2018 Mesrop Kareyan. All rights reserved.
//

import UIKit

//MARK: - Table view
extension LinksTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! LinkTableViewCell
        cell.updateCell()
    }
    
    //MARK: Deleting
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            let link = linkStore.links[indexPath.row]
            showDeleteAlert(for: link, atIndex: indexPath.row)
        }
    }
    
    func indexPath(for link: Link) -> IndexPath? {
        guard let linkIndex = self.linkStore.links.index(of: link) else { return nil }
        return IndexPath(row: linkIndex, section: 0)
    }
    
    func insertCell(at newIndex: Int?) {
        DispatchQueue.main.async {
            guard let index = newIndex else { return }
            let indexPath = IndexPath(row: index, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    func updateCell(for link: Link)  {
        guard let indexPath = indexPath(for: link),
            let _ = tableView.cellForRow(at: indexPath) as? LinkTableViewCell else  { return }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    
}

