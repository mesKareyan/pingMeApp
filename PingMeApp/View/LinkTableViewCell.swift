//
//  LinkTableViewCell.swift
//  PingMeApp
//
//  Created by Mesrop Kareyan on 5/14/18.
//  Copyright © 2018 Mesrop Kareyan. All rights reserved.
//

import UIKit

class LinkTableViewCell: UITableViewCell {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    var link: Link!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        statusView.layer.cornerRadius = statusView.bounds.width / 2
        statusView.clipsToBounds = true
    }
    
    func updateCell() {
        guard let link = self.link else {
            return
        }
        switch link.status {
          case .available:
            statusView.backgroundColor = .green
          case .unAvailable:
            statusView.backgroundColor = .red
          case .noInformation:
            statusView.backgroundColor = UIColor.groupTableViewBackground
        }
    }
    
}
