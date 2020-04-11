//
//  CoreDataCollectionProperty.swift
//  VirtualTourist
//
//  Created by Jan Skála on 10/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation
import CoreData

class CoreDataCollectionProperty<T: NSManagedObject> : ObservableProperty<CoreDataResult<T>>{
    typealias ItemUpdateHandler = (T)->Void
    
    private let dataController = DataController.shared
    
    func load(notifyLoading: Bool = true){
        if(notifyLoading){
            setValue(.loading)
        }
        let fetchRequest = NSFetchRequest<T>(entityName: "Pin")
        do{
            let value = try dataController.viewContext.fetch(fetchRequest)
            setValue(.success(value))
        }catch{
            setValue(.error(error))
        }

    }
    
    @objc func changeNotificationReceived(notification: Notification){
        guard let userInfo = notification.userInfo else { return }

        DispatchQueue.global(qos: .background).async {
            var changeFlag = false
            
            if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>, inserts.count > 0 {
                changeFlag = inserts.contains { (object) -> Bool in
                    return object is T
                }
                
                if(changeFlag){
                    print("Insert detected \(self.id)")
                }
            }

            if !changeFlag, let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject>, updates.count > 0 {
                changeFlag = updates.contains { (object) -> Bool in
                      return object is T
                }
                
                if(changeFlag){
                    print("Update detected \(self.id)")
                }
            }

            if !changeFlag, let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>, deletes.count > 0 {
                changeFlag = deletes.contains { (object) -> Bool in
                      return object is T
                }
                
                if(changeFlag){
                    print("Delete detected \(self.id)")
                }
            }
            
            if(changeFlag){
                DispatchQueue.main.async {
                    self.load(notifyLoading: false)
                }
            }
        }
    }
    
    func updateItem(item: T, updateHandler: @escaping ItemUpdateHandler){
        updateItem(id: item.objectID, updateHandler: updateHandler)
    }
    
    func updateItem(id: NSManagedObjectID, updateHandler: @escaping ItemUpdateHandler){
        dataController.backgroundContext.perform {
            let value = self.dataController.backgroundContext.object(with: id) as! T
            updateHandler(value)
            try? self.dataController.backgroundContext.save()
        }
    }
    
    func deleteItem(item: T){
        dataController.backgroundContext.delete(item)
    }
    
    override func afterCallbackAdd() {
        if(callbacks.count == 1){
            NotificationCenter.default.addObserver(self, selector: #selector(changeNotificationReceived(notification:)), name: .NSManagedObjectContextObjectsDidChange, object: nil)
        }
        if value == nil || value!.isError(){
            load()
        }
    }
    
    override func afterCallbackRemove() {
        if(callbacks.isEmpty){
            NotificationCenter.default.removeObserver(self)
        }
    }
}
