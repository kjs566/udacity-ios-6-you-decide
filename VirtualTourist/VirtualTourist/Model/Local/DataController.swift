//
//  DataController.swift
//  VirtualTourist
//
//  Created by Jan Skála on 10/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation
import CoreData

class DataController{
    static let shared = DataController(modelName: "LocalModel")
    var ready = false
    
    let persistentContainer: NSPersistentContainer
    
    let viewContext: NSManagedObjectContext
    
    let backgroundContext: NSManagedObjectContext
    
    init(modelName: String){
        persistentContainer = NSPersistentContainer(name: modelName)
        viewContext = persistentContainer.viewContext
        backgroundContext = persistentContainer.newBackgroundContext()
        viewContext.automaticallyMergesChangesFromParent = true
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
        backgroundContext.automaticallyMergesChangesFromParent = true
        backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        load()

    }
    
    func load(completion: (()->Void)? = nil){
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            guard error == nil else { fatalError(error!.localizedDescription) }
                        
            self.ready = true
            completion?()
        }
    }
    
    @discardableResult
    func createAndSave<T: NSManagedObject>(initializer: (T)->Void, errorHandler: ((Error)->Void)?, background: Bool = false) -> NSManagedObjectID?{
        let context = background ? backgroundContext : viewContext

        let object = T(context: context)
        initializer(object)
        saveContext(context, errorHandler: errorHandler)
        
        if !object.objectID.isTemporaryID {
            return object.objectID
        } else {
            print("Temporary object id deteced")
            return nil
        }
    }
    
    func remove<T: NSManagedObject>(_ toRemove: T, errorHandler: ((Error)->Void)?){
        viewContext.delete(toRemove)
        saveContext(viewContext, errorHandler: errorHandler)
    }
    
    func update<T: NSManagedObject>(id: NSManagedObjectID, updater: @escaping (T)->Void, errorHandler: ((Error)->Void)? = nil){
        let object = self.viewContext.object(with: id) as! T
        updater(object)
        self.saveContext(self.viewContext, errorHandler: errorHandler)
    }
    
    func updateBackground<T: NSManagedObject>(id: NSManagedObjectID, updater: @escaping (T)->Void, errorHandler: ((Error)->Void)? = nil){
        backgroundContext.perform {
            let object = self.backgroundContext.object(with: id) as! T
            updater(object)
            self.saveContext(self.backgroundContext, errorHandler: errorHandler, fromBackground:  true)
        }
    }
    
    func saveContext(_ context: NSManagedObjectContext, errorHandler: ((Error)->Void)? = nil, fromBackground: Bool = false){
        do{
            try context.save()
        }catch{
            guard let errorHandler = errorHandler else { return }
            if fromBackground {
                DispatchQueue.main.async {
                    errorHandler(error)
                }
            }else{
                errorHandler(error)
            }
        }
    }
}
