//
//  LinksStore.swift
//  PingMeApp
//
//  Created by Mesrop Kareyan on 5/15/18.
//  Copyright © 2018 Mesrop Kareyan. All rights reserved.
//

import Foundation

class LinksStore {
    
    private (set) var links: [Link] = [
        Link(address: "google.com"),
        Link(address: "facebook.com"),
        Link(address: "amzn.to")
    ]
    
    func remove(link: Link) {
        if let index = links.index(of: link) {
            links.remove(at: index)
        }
    }
    
    func add(link: Link) {
        links.append(link)
    }
    
    init() {
    }
    
}

class LinkChecker {
    
    init() {}
    
    func updatePing(for link: Link, comletion: @escaping (_ success: Bool) -> ()) {
        Network.checkPing(for: link.address) { (result) in
        let success = self.updatePingResult(for: link, with: result)
            DispatchQueue.main.async {
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
            link.pingTime = ping
            return true
        }
    }
    
}
