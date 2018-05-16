//
//  LinksStore.swift
//  PingMeApp
//
//  Created by Mesrop Kareyan on 5/15/18.
//  Copyright © 2018 Mesrop Kareyan. All rights reserved.
//

import Foundation
import RealmSwift

enum LinksSorting {
    
    case nameAsc
    case nameDesc
    case statusAsc
    case statusDesc
    case pingTimeAsc
    case pingTimeDesc
    case none
    
    var value: String {
        switch self {
        case .nameAsc, .nameDesc :
            return "address"
        case .statusAsc, .statusDesc:
            return "status"
        case .pingTimeAsc, .pingTimeDesc:
            return "ping"
        case .none:
            return ""
        }
    }
    
    var ascending: Bool {
        switch self {
        case .nameAsc, .statusAsc, .pingTimeAsc :
            return true
        case .nameDesc, .statusDesc, .pingTimeDesc:
            return false
        case .none:
            return false
        }
    }
    
}

extension LinksSorting {
    static prefix func !(value: LinksSorting) -> LinksSorting {
        switch value {
        case .nameAsc:
            return .nameDesc
        case .nameDesc:
            return .nameAsc
        case .statusAsc:
            return .statusDesc
        case .statusDesc:
            return .statusAsc
        case .pingTimeAsc:
            return .pingTimeDesc
        case .pingTimeDesc:
            return .pingTimeAsc
        case .none:
            return .none
        }
    }
}

class LinksStore {
    
    private (set) var links: Results<Link>!
    let realm = try! Realm()
    
    var searchPredicate: NSPredicate?
    var sortBy: LinksSorting = .nameAsc

    init() {
        loadLinks()
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
                      .sorted(byKeyPath: sortBy.value, ascending: sortBy.ascending)
            } else {
                return realm.objects(Link.self)
                    .filter(searchPredicate!)
            }
        } else {
            if sorted {
               return realm.objects(Link.self)
                    .sorted(byKeyPath: sortBy.value, ascending: sortBy.ascending)
            } else {
                return realm.objects(Link.self)
            }
        }
    }
    
    func create(link address: String, index added: (Int?) ->()) {
        do {
            let link = Link(address: address)
            try realm.write {
                realm.add(link, update: true)
                loadLinks()
                guard let index = links.index(of: link) else {
                    added(nil)
                    return
                }
                added(index)
            }
        } catch let error as NSError {
            added(nil)
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

    func update(ping: TimeInterval, for link: Link) {
        try! realm.write {
            link.pingTime = ping
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
        switch result {
        case .failure(error: let error):
            link.status = .unavailable
            print("Error: \(link)\n\(error)")
            return false
        case .success(pingTime: let ping):
            link.status = .available
            linkStore.update(ping: ping, for: link)
            return true
        }
    }
    
}
