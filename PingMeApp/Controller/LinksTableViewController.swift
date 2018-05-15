//
//  ViewController.swift
//  PingMeApp
//
//  Created by Mesrop Kareyan on 5/14/18.
//  Copyright © 2018 Mesrop Kareyan. All rights reserved.
//

import UIKit

class LinksTableViewController: UIViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet weak var tableView: UITableView!
    var linkStore: LinksStore!
    var filteredLinks: [Link] = []
    var isSearchingActive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        linkStore =  LinksStore()
        configureSearchBar()
        configureAppearance()
    }
    //MARK: - UI
    func configureSearchBar() {
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.barStyle = .black
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1058823529, green: 0.6784313725, blue: 0.9725490196, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes =
             [NSAttributedStringKey.foregroundColor : UIColor.white]
        navigationItem.title = "Ping"
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationBar.largeTitleTextAttributes =
                [NSAttributedStringKey.foregroundColor : UIColor.white]
            navigationItem.hidesSearchBarWhenScrolling = true
            navigationItem.searchController = searchController
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }
    }
    
    func configureAppearance() {
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "Search links", attributes: [NSAttributedStringKey.foregroundColor: UIColor.orange])
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.orange]
        searchController.searchBar.tintColor = UIColor.orange
        if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            if let backgroundview = textfield.subviews.first {
                backgroundview.backgroundColor = UIColor.white
                backgroundview.layer.cornerRadius = 10
                backgroundview.clipsToBounds = true
            }
        }
    }
    //MARK: - Actions
    
}

//MARK: - Table view
extension LinksTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchingActive ? filteredLinks.count : linkStore.links.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LinkTableViewCell") as! LinkTableViewCell
        let link = isSearchingActive ?
            filteredLinks[indexPath.row] : linkStore.links[indexPath.row]
        cell.link = link
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

extension LinksTableViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //Show Cancel
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.tintColor = .white
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //Filter function
        //self.filterFunction(searchText: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //Hide Cancel
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        guard let term = searchBar.text , !term.isEmpty else {
            return
        }
        //Filter function
        filterLinks(with: term)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //Hide Cancel
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.text = String()
        searchBar.resignFirstResponder()
        //Filter function
        guard let term = searchBar.text , !term.isEmpty else {
            return
        }
        filterLinks(with: term)
    }
    
    func filterLinks(with searchText: String) {
        filteredLinks = linkStore.links.filter { $0.adress.contains(searchText) }
        tableView.reloadData()
    }
    
}

