//
//  Link.swift
//  PingMeApp
//
//  Created by Mesrop Kareyan on 5/16/18.
//  Copyright © 2018 Mesrop Kareyan. All rights reserved.
//

import Foundation
import RealmSwift

enum LinkStatus: Int {
    case available
    case unavailable
    case noInformation
}

class Link: Object {
    
    @objc dynamic private(set) var address: String = ""
    @objc dynamic var pingTime: TimeInterval = 0.0
    @objc private dynamic var _status = LinkStatus.noInformation.rawValue
    var status: LinkStatus {
        get { return LinkStatus(rawValue: _status)! }
        set { _status = newValue.rawValue }
    }
    var isUpdating = false

    convenience init(address: String) {
        self.init()
        self.address = address
    }
    
    override static func primaryKey() -> String? {
        return "address"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["isUpdating"]
    }
    

}

//extension Link: Hashable {
//    var hashValue: Int {
//        return address.hashValue
//    }
//}
//
//extension Link: Equatable {
//    static func == (lhs: Link, rhs: Link) -> Bool {
//        return lhs.address == rhs.address
//    }
//}

