//
//  Link.swift
//  PingMeApp
//
//  Created by Mesrop Kareyan on 5/16/18.
//  Copyright © 2018 Mesrop Kareyan. All rights reserved.
//

import Foundation

enum LinkStatus {
    case available
    case unavailable
    case noInformation
}

class Link {
    var address: String
    var status: LinkStatus = .noInformation
    var pingTime: TimeInterval?
    
    init(address: String) {
        self.address = address
    }
}

extension Link: Hashable {
    var hashValue: Int {
        return address.hashValue
    }
}

extension Link: Equatable {
    static func == (lhs: Link, rhs: Link) -> Bool {
        return lhs.address == rhs.address
    }
}

