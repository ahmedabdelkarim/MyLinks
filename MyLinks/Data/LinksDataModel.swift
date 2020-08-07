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
    
    
    //MARK: - Functions
//    func getLinks() -> [Link] {
//        let fetchRequest:NSFetchRequest<LinkEntity> = LinkEntity.fetchRequest()
//
//        do {
//            let entityArray = try context.fetch(fetchRequest)
//
//            let array = entityArray.map({ (entity) -> Link in
//                let item = Link(title: entity.title!, url: entity.url!, linkEntity: entity)
//                return item
//            })
//
//            return array.reversed()
//        } catch {
//            return [Link]()
//        }
//    }
//
//    func addLink(link:Link) -> Bool {
//        let entity = LinkEntity(context: context)
//        if(link.title != nil && !link.title!.isEmpty) {
//            entity.title = link.title
//        }
//        entity.url = link.url
//
//        return saveContext()
//    }
//
//    func deleteLink(link:Link) -> Bool {
//        //link.linkEntity.managedObjectContext?.delete(link.linkEntity)
//        context.delete(link.linkEntity)
//
//        return saveContext()
//    }
//
//    func deleteAllLinks() -> Bool {
//        let fetchRequest:NSFetchRequest<LinkEntity> = LinkEntity.fetchRequest()
//        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
//
//        do {
//            try context.execute(batchDeleteRequest)
//            return true
//        } catch {
//            return false
//        }
//    }
}
