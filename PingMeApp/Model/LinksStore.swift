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
        Link(adress: "google.com"),
        Link(adress: "facebook.com"),
        Link(adress: "amzn.to")
    ]
    
    func remove(link: Link) {
        if let index = links.index(of: link) {
            links.remove(at: index)
        }
    }
    
    init() {
    }
    
}

struct Link {
    var adress: String
    var status: LinkStatus = .noInformation
    init(adress: String) {
        self.adress = adress
    }
}

extension Link: Hashable {
    var hashValue: Int {
        return adress.hashValue
    }
}

extension Link: Equatable {
    static func == (lhs: Link, rhs: Link) -> Bool {
        return lhs.adress == rhs.adress
    }
}

enum LinkStatus {
    case available
    case unAvailable
    case noInformation
}
