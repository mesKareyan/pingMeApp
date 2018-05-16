//
//  LinkTable+Searching.swift
//  PingMeApp
//
//  Created by Mesrop Kareyan on 5/16/18.
//  Copyright © 2018 Mesrop Kareyan. All rights reserved.
//

import UIKit

extension LinksTableViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //Show Cancel
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.tintColor = .white
        self.coverView.isHidden = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterLinks(with: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //Hide Cancel
        searchPredicate = nil
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
        self.coverView.isHidden = true
        searchPredicate = nil
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
        if searchText.isEmpty {
            searchPredicate = nil
            return
        }
       searchPredicate = NSPredicate(format: "address contains[c] %@", searchText)
    }
    
}




