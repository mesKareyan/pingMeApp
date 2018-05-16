//
//  LinksStore.swift
//  PingMeApp
//
//  Created by Mesrop Kareyan on 5/15/18.
//  Copyright © 2018 Mesrop Kareyan. All rights reserved.
//

import Foundation
import RealmSwift

enum LinksSortBy: String {
    case address
    case _status
    case pingTime
    case none
}

enum LinksOrderBy {
    case ascending
    case descending
    var isAscending: Bool {
        return self == .ascending
    }
    static prefix func !(order: LinksOrderBy) -> LinksOrderBy {
        switch order {
        case .ascending:
            return .descending
        case .descending:
            return .ascending
        }
    }
}

enum NewLinkCreation {
    case success(link: Link)
    case fail
}
typealias NewLinkCreationCompletion = (NewLinkCreation) -> ()

class LinksStore {
    
    private (set) var links: Results<Link>!
    let realm = try! Realm()

    var searchPredicate: NSPredicate?
    var sortBy: LinksSortBy = .pingTime
    var odrerBy: LinksOrderBy = .ascending

    init() {
        initialLoadingForLinks()
    }
    
    func initialLoadingForLinks() {
        loadLinks()
        for link in links {
            if link.status == .updating {
                update(link, status: .noInformation)
            }
        }
    }
    
    func loadLinks() {
        do {
            let realm = try Realm()
            let isFilterEnabled = searchPredicate != nil
            let isSortEnabled = sortBy != .none
            self.links = objects(from: realm, filtered: isFilterEnabled , sorted: isSortEnabled)
        } catch let error as NSError {
            self.links = nil
            fatalError(error.localizedDescription)
        }
    }
    
    private func objects(from realm: Realm, filtered:Bool, sorted: Bool) -> Results<Link> {
        if filtered {
            if sorted {
               return realm.objects(Link.self)
                      .filter(searchPredicate!)
                      .sorted(byKeyPath: sortBy.rawValue, ascending: self.odrerBy.isAscending)
            } else {
                return realm.objects(Link.self)
                    .filter(searchPredicate!)
            }
        } else {
            if sorted {
               return realm.objects(Link.self)
                    .sorted(byKeyPath: sortBy.rawValue, ascending: self.odrerBy.isAscending)
            } else {
                return realm.objects(Link.self)
            }
        }
    }
    
    //MARK: - CRUD
    func create(link address: String, completion: NewLinkCreationCompletion) {
        do {
            let link = Link(address: address)
            try realm.write {
                realm.add(link, update: true)
                loadLinks()
                guard let _ = links.index(of: link) else {
                    completion(.fail)
                    return
                }
                completion(.success(link: link))
            }
        } catch let error as NSError {
            completion(.fail)
            fatalError(error.localizedDescription)
        }
    }
    
    func remove(link: Link,index removed: (Int?) ->())  {
        guard let index = links.index(of: link) else {
            removed(nil)
            return
        }
        do {
            try realm.write {
                realm.delete(link)
                removed(index)
            }
        } catch {
            print(error)
            removed(nil)
        }
    }
    
    func update(_ link: Link,status: LinkStatus,ping: TimeInterval = 0) {
        try! realm.write {
            link.status = status
            link.pingTime = ping
        }
    }
    
    func updateAllLinks(completion: ()->()) {
        try! realm.write {
            for link in links {
                link.status = .updating
            }
            //finsed updating
            completion()
        }
    }

}

class LinkChecker {
    
    init(store: LinksStore) {
        self.linkStore = store
    }
    
    let realm = try! Realm()
    let linkStore: LinksStore!
    
    func updatePing(for link: Link, comletion: @escaping (_ success: Bool) -> ()) {
        Network.checkPing(for: link.address) { (result) in
            DispatchQueue.main.async {
                let success = self.updatePingResult(for: link, with: result)
                comletion(success)
            }
        }
    }
    
    private func updatePingResult(for link: Link, with result: NetworkResult) -> Bool {
        
        guard !link.isInvalidated else { return false }
        
        switch result {
        case .failure(error: let error):
            linkStore.update(link, status: .unavailable)
            print("Error: \(link)\n\(error)")
            return false
        case .success(pingTime: let ping):
            linkStore.update(link, status: .available, ping: ping)
            return true
        }
    }
    
}
