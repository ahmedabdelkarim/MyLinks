//
//  CoreDataModel.swift
//  MyLinks
//
//  Created by Ahmed Abdelkarim on 8/4/20.
//  Copyright © 2020 Ahmed Abdelkarim. All rights reserved.
//

import Foundation
import CoreData

/// Contains common implementation for a data model.
class CoreDataModel {
    //MARK: - Init
    init() {
        context = persistentContainer.viewContext
    }
    
    //MARK: - Variables
    /// Override this in subclass by setting data model name.
    var persistentContainerName:String! { "" }
    
    var context: NSManagedObjectContext!
    
    var persistentContainer: NSPersistentContainer {
        get {
            let container = NSPersistentContainer(name: persistentContainerName)
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            
            return container
        }
    }
    
    //MARK: - Functions
    func saveContext() -> Bool {
        if(context.hasChanges) {
            do {
                try context.save()
                return true
            } catch {
                return false
            }
        }
        else {
            return true
        }
    }
}
