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
    case updating
}

class Link: Object {
    
    @objc dynamic private(set) var address: String = ""
    @objc dynamic var pingTime: TimeInterval = 0.0
    @objc private dynamic var _status = LinkStatus.noInformation.rawValue
    var status: LinkStatus {
        get { return LinkStatus(rawValue: _status)! }
        set { _status = newValue.rawValue }
    }

    convenience init(address: String) {
        self.init()
        self.address = address
    }
    
    override static func primaryKey() -> String? {
        return "address"
    }
    

}

