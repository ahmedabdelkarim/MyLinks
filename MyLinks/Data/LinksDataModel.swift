//
//  LinksDataModel.swift
//  MyLinks
//
//  Created by Ahmed Abdelkarim on 8/4/20.
//  Copyright © 2020 Ahmed Abdelkarim. All rights reserved.
//

import Foundation
import CoreData

/// Any changes made with an instance of this model have to be saved in the same instance, or changes will be lost.
class LinksDataModel : CoreDataModel {
    //MARK: - Variables
    override var persistentContainerName:String! { "Links" }
    
    //MARK: - Properties
    var links:CoreDataArray<LinkEntity>!
    //..other properties for other entities
    
    //MARK: - Init
    override init() {
        super.init()
        
        links = CoreDataArray<LinkEntity>(context: context, initialFetch: false)
        //..init other properties for other entities
    }
}
