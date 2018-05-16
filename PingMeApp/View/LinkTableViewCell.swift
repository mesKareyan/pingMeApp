//
//  LinkTableViewCell.swift
//  PingMeApp
//
//  Created by Mesrop Kareyan on 5/14/18.
//  Copyright © 2018 Mesrop Kareyan. All rights reserved.
//

import UIKit

class LinkTableViewCell: UITableViewCell {
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    var link: Link!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        statusView.layer.cornerRadius = statusView.bounds.width / 2
        statusView.clipsToBounds = true
        spinner.isHidden = true
        descriptionLabel.textColor = UIColor.lightGray
    }
    
    func configure(for link: Link) {
        self.link = link
        descriptionLabel.text = link.address
        if link.pingTime != 0.0 {
            let pingInMS = String(format: "%.2fms", link.pingTime);
            statusLabel.text = pingInMS;
        } else {
            statusLabel.text = ""
        }
    }
    
    func startLoading() {
        descriptionLabel.isHidden = true
        spinner.isHidden = false
        spinner.startAnimating()
    }
    
    func finishLoading() {
        descriptionLabel.isHidden = false
        spinner.isHidden = true
        spinner.stopAnimating()
    }
    
    func updateCell() {
        guard let link = self.link else {
            return
        }
        switch link.status {
          case .available:
            statusView.backgroundColor = .green
            self.finishLoading()
          case .unavailable:
            statusView.backgroundColor = .red
            self.finishLoading()
          case .noInformation:
            statusView.backgroundColor = UIColor.groupTableViewBackground
            self.finishLoading()
        }
        if link.isUpdating {
            statusView.backgroundColor = UIColor.groupTableViewBackground
            self.startLoading()
        } else {
            self.finishLoading()
        }
    }
    
}
