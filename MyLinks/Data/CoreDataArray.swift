//
//  CoreDataArray.swift
//  MyLinks
//
//  Created by Ahmed Abdelkarim on 8/7/20.
//  Copyright © 2020 Ahmed Abdelkarim. All rights reserved.
//

import Foundation
import CoreData

/// Array of NSManagedObject which handles the main operations.
class CoreDataArray<T> where T:NSManagedObject {
    //MARK: - Variables
    private var context:NSManagedObjectContext!
    private var items:[T]?
    
    //MARK: - Properties
    /// Number of items in array.
    var count:Int! {
        get {
            return items != nil ? items!.count : 0
        }
    }
    
    //MARK: - Indexer
    /// Allows access to items using index in brackets (ex. [index]).
    subscript(index:Int) -> T? {
        return items != nil ? items![index] : nil
    }
    
    //MARK: - Init
    /// Initialize array of NSManagedObject and link it to its context.
    /// - Parameters:
    ///   - context: The context of NSManagedObject which is used to manage changes to that object.
    ///   - initialFetch: If true, items are fetched from database while initializing. If false, item are not fetched and should be fetched explicitly by calling fetchFromDatabase.
    init(context:NSManagedObjectContext, initialFetch:Bool = true) {
        self.context = context
        
        if(initialFetch) {
            fetchFromDatabase()
        }
    }
    
    //MARK: - Functions
    /// Get an item with index.
    /// - Parameter index: The index of the required item.
    func elementAt(_ index:Int) -> T? {
        return items != nil ? items![index] : nil
    }
    
    func copy() -> [T]? {
        return items.map { $0 }
    }
    
    /// Read items from database.
    func fetchFromDatabase() {
        let fetchRequest:NSFetchRequest<T> = T.fetchRequest() as! NSFetchRequest<T>
        items = try? context.fetch(fetchRequest) // items will be nil if fetch throws
    }
    
    /// Creates a new item in array (without saving context). Context should be saved after setting item values.
    func create() -> T {
        let entity = T(context: context)
        items?.append(entity)
        
        return entity
    }
    
    /// Delete an item in array (without saving context).
    func delete(item:T?) -> Bool {
        if(items != nil && items!.contains(item!)) {
            //remove from database
            context.delete(item!)
            //remove from items
            let index = items!.firstIndex { $0 === item }
            items!.remove(at: index!)
            
            return true
        }
        else {
            return false
        }
    }
    
    /// Delete an item in the specified index (without saving context).
    func deleteAt(index:Int) -> Bool {
        if(items != nil && index < count) {
            //remove from database
            context.delete(items![index])
            //remove from items
            items!.remove(at: index)
            
            return true
        }
        else {
            return false
        }
    }
    
    /// Delete all items in array (without saving context).
    func clear() -> Bool {
        //initialize delete request
        let fetchRequest:NSFetchRequest<T> = T.fetchRequest() as! NSFetchRequest<T>
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        
        //execute delete request
        do {
            try context.execute(batchDeleteRequest)
            return true
        } catch {
            return false
        }
    }
}
