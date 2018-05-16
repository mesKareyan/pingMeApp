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
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let link = self.linkStore.links[indexPath.row]
            if link.status == .updating {
                self.showDeleteAlert(for: link, atIndex: indexPath.row)
            } else {
                self.remove(link)
            }
        }
        let update = UITableViewRowAction(style: .normal, title: "Update") { (action, indexPath) in
            let link = self.linkStore.links[indexPath.row]
            self.updatePing(for: link)
        }
        delete.backgroundColor = UIColor.orange
        update.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
        return [delete, update]
        
    }
    
    //MARK: Helpers
    func indexPath(for link: Link) -> IndexPath? {
        guard !link.isInvalidated else { return nil }
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
    
    func updateCell(at newIndex: Int?) {
        DispatchQueue.main.async {
            guard let index = newIndex else { return }
            let indexPath = IndexPath(row: index, section: 0)
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func updateCell(for link: Link)  {
        guard let indexPath = indexPath(for: link),
        let cell = tableView.cellForRow(at: indexPath) as? LinkTableViewCell else  {
            return
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
        cell.finishLoading()
    }
    
    
}

