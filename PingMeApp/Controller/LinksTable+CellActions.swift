//
//  LinksTable+CellActions.swift
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
            self.linkStore.create(link: url.absoluteString, index: { (newIndex) in
                self.insertCell(at: newIndex)
            })
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
    //MARK: - Updating
    func updatePing(for link: Link) {
        self.linkChecker.updatePing(for: link, comletion: { [weak welf = self] (success) in
            print(success)
            if let strongSelf = welf {
                strongSelf.updateCell(for: link)
            }
        })
    }
    //MARK: - Deleting
    func showDeleteAlert(for link: Link, atIndex: Int) {
        let alert = UIAlertController(title: "Delete link for list",
                                      message: "Are you sure?",
                                      preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                //delete the link
                self.linkStore.remove(link: link, index: { [weak weakSelf = self] (removedIndex) in
                    guard let strongSelf = weakSelf, let index = removedIndex else { return }
                    let indexPath = IndexPath(row: index, section: 0)
                    strongSelf.tableView.deleteRows(at: [indexPath], with: .automatic)
                })
            })
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}
