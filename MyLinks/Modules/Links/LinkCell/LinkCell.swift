//
//  LinkCell.swift
//  MyLinks
//
//  Created by Ahmed Abdelkarim on 8/4/20.
//  Copyright © 2020 Ahmed Abdelkarim. All rights reserved.
//

import UIKit

class LinkCell: UITableViewCell {
    //MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    
    //MARK: - Variables
    private var link:LinkEntity!
    
    //MARK: - Functions
    func setup(link:LinkEntity) {
        self.link = link
        
        titleLabel.text = link.title
        urlLabel.text = link.url
    }
}
