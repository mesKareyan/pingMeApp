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
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var filterButton: UIBarButtonItem!
    @IBOutlet weak var orderButton: UIBarButtonItem!
    @IBOutlet weak var coverView: UIView!
    
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
            self.linkStore.searchPredicate = searchPredicate
            self.linkStore.loadLinks()
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = linksDataSource
        configureSearchBar()
        configureAppearance()
        self.orderButton.image =
            self.linkStore.odrerBy.isAscending ? #imageLiteral(resourceName: "sort-up") : #imageLiteral(resourceName: "sort-down")
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
    @IBAction func coverViewTapped(_ sender: UITapGestureRecognizer) {
        self.coverView.isHidden = true
        searchController.searchBar.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    @IBAction func refreshButtonTapped(_ sender: UIBarButtonItem) {
        self.refreshButton.isEnabled = false
        //make all links statuses updated
        linkStore.updateAllLinks {
            //show spinners
            self.tableView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                let dispatchGroup = DispatchGroup()
                for link in self.linkStore.links  {
                    dispatchGroup.enter()
                    //relaod each cell
                    self.updatePing(for: link) {
                        dispatchGroup.leave()
                    }
                }
                dispatchGroup.notify(queue: .main) {
                    //all cells ware successfully relaoded
                    self.tableView.reloadData()
                    self.refreshButton.isEnabled = true
                }
            })
        }
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        showNewLinkAlert()
    }
    
    @IBAction func filterButtonTapped(_ sender: UIBarButtonItem) {
        let style: UIAlertControllerStyle
        if UIDevice.current.userInterfaceIdiom == .pad {
            style = .alert
        } else {
            style = .actionSheet
        }
        let alert = UIAlertController(title: "Sort by", message: "sorted by \(self.linkStore.sortBy.rawValue)", preferredStyle: style)
        let sortbyName = UIAlertAction(title: "By adress", style: .default)
        { action in
            self.linkStore.sortBy = .address
            self.linkStore.loadLinks()
            self.tableView.reloadData()
        }
        let sortbyAvailability = UIAlertAction(title: "By availability", style: .default)
        { action in
            self.linkStore.sortBy = ._status
            self.linkStore.loadLinks()
            self.tableView.reloadData()

        }
        let sortbyPingTime = UIAlertAction(title: "By ping time", style: .default)
        { action in
            self.linkStore.sortBy = .pingTime
            self.linkStore.loadLinks()
            self.tableView.reloadData()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(sortbyName)
        alert.addAction(sortbyAvailability)
        alert.addAction(sortbyPingTime)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func oderButtonTapped(_ sender: UIBarButtonItem) {
        self.linkStore.odrerBy = !self.linkStore.odrerBy
        self.linkStore.loadLinks()
        self.tableView.reloadData()
        self.orderButton.image =
            self.linkStore.odrerBy.isAscending ? #imageLiteral(resourceName: "sort-up") : #imageLiteral(resourceName: "sort-down")
    }
    
}


