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
    
    lazy var viewContext =  persistentContainer.viewContext
    
    lazy var backgroundContext = persistentContainer.newBackgroundContext()
    
    init(modelName: String){
        persistentContainer = NSPersistentContainer(name: modelName)
        load()
    }
    
    func load(completion: (()->Void)? = nil){
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            guard error == nil else { fatalError(error!.localizedDescription) }
            
            self.viewContext.automaticallyMergesChangesFromParent = true
            self.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
            self.backgroundContext.automaticallyMergesChangesFromParent = true
            self.backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            
            self.ready = true
            completion?()
        }
    }
    
    func createAndSave<T: NSManagedObject>(initializer: (T)->Void, errorHandler: (Error)->Void, background: Bool = false){
        let context = background ? backgroundContext : viewContext

        initializer(T(context: context))
        saveContext(context, errorHandler: errorHandler)
    }
    
    private func saveContext(_ context: NSManagedObjectContext, errorHandler: (Error)->Void){
        do{
            try context.save()
        }catch{
            errorHandler(error)
        }
    }
}
