//
//  LinksTable+CellsLoading.swift
//  PingMeApp
//
//  Created by Mesrop Kareyan on 5/16/18.
//  Copyright © 2018 Mesrop Kareyan. All rights reserved.
//

import UIKit

extension LinksTableViewController {
    //MARK: - Inserting
    func showNewLinkAlert() {
        
        func validateUrl(link: String?) -> Bool {
            guard let urlLink = link, !urlLink.isEmpty else { return false }
            let urlRegEx = "((?:http|https)://)?(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?"
            let isValidLink = NSPredicate(format: "SELF MATCHES %@", urlRegEx).evaluate(with: link)
            return isValidLink
        }
        
        func url(from linkString: String) -> URL? {
            
            let hasHTTPPrefix = linkString.hasPrefix("http://www.");
            let hasHTTPSPrefix = linkString.hasPrefix("https://www.");
            
            if hasHTTPPrefix || hasHTTPSPrefix {
                return URL(string: linkString)
            }
            
            let linkString = "https://www." + linkString
            return URL(string: linkString)
        }
        
        func showValidationAlert() {
            let alert = UIAlertController(title: "Please enter valid link",
                                          message: "", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
        }
        
        let alert = UIAlertController(title: "Add new link", message: "enter link", preferredStyle: .alert)
        let add = UIAlertAction(title: "OK", style: .default) { (action) in
            let textFiled = alert.textFields!.first!
            let isValidLink = validateUrl(link: textFiled.text)
            guard isValidLink, let url = url(from: textFiled.text!) else {
                showValidationAlert()
                return
            }
            let link = Link(address: url.absoluteString)
            self.linkStore.add(link: link)
            self.insertCell(for: link)
            self.updatePing(for: link)
        }
        alert.addTextField { (textFiled) in
            textFiled.placeholder = "Enter the link"
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(add)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    private func updatePing(for link: Link) {
        guard let indexPath = indexPath(for: link) else { return }
        let cell = tableView.cellForRow(at: indexPath) as! LinkTableViewCell
        cell.startLoading()
        self.linkChecker.updatePing(for: link, comletion: { [weak welf = self] (success) in
            print(success)
            if let strongSelf = welf {
                strongSelf.updateCell(for: link)
            }
        })
    }
    
    private func indexPath(for link: Link) -> IndexPath? {
        guard let linkIndex = self.isSearchingActive ?
            self.filteredLinks.index(of: link) : self.linkStore.links.index(of: link)
            else {
                return nil
        }
        return IndexPath(row: linkIndex, section: 0)
    }
    
    private func insertCell(for link: Link) {
        guard let indexPath = indexPath(for: link) else { return }
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    private func updateCell(for link: Link)  {
        guard let indexPath = indexPath(for: link) else { return }
        let cell = tableView.cellForRow(at: indexPath) as! LinkTableViewCell
        tableView.reloadRows(at: [indexPath], with: .automatic)
        cell.finishLoading()
    }
}
