//
//  ViewController.swift
//  PingMeApp
//
//  Created by Mesrop Kareyan on 5/14/18.
//  Copyright © 2018 Mesrop Kareyan. All rights reserved.
//

import UIKit
import RealmSwift


class LinksTableViewController: UIViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet weak var tableView: UITableView!
    
    lazy var linkStore: LinksStore! = {
        let linkStore = LinksStore()
        return linkStore
    }()
    
    lazy var linkChecker: LinkChecker! = {
        let linkChecker = LinkChecker(store: linkStore)
        return linkChecker
    }()
    
    lazy var linksDataSource: LinksTableDataSource! = {
        let dataSource = LinksTableDataSource(with: linkStore)
        return dataSource
    }()
    
    var searchPredicate: NSPredicate? = nil {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = linksDataSource
        configureSearchBar()
        configureAppearance()
    }
    //MARK: - UI
    func configureSearchBar() {
        searchController.searchBar.delegate = self
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
    @IBAction func refreshButtonTapped(_ sender: UIBarButtonItem) {
        for link in linkStore.links {
            updatePing(for: link)
        }
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        showNewLinkAlert()
    }
    
    @IBAction func filterButtonTapped(_ sender: UIBarButtonItem) {
    }

    
}


