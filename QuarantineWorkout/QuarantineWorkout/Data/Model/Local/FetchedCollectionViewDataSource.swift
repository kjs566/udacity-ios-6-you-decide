//
//  FetchedCollectionSource.swift
//  QuarantineWorkout
//
//  Created by Jan Skála on 13/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class FetchedCollectionViewDataSource: NSObject{
    weak var delegate: FetchedCollectionViewDataSourceDelegate? = nil
    
    let sortDescriptors: [NSSortDescriptor]
    let fetchRequest: NSFetchRequest<NSManagedObject>
    weak var collectionView: UICollectionView? = nil
    
    var updateOperations: [BlockOperation] = []
    
    lazy var fetchedResultsController: NSFetchedResultsController<NSManagedObject> = {
        fetchRequest.sortDescriptors = sortDescriptors
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataController.shared.viewContext, sectionNameKeyPath: nil, cacheName: nil)

        fetchedResultsController.delegate = self

        return fetchedResultsController
    }()
    
    init(collectionView: UICollectionView, sortDescriptors : [NSSortDescriptor], fetchRequest: NSFetchRequest<NSManagedObject>) {
        self.sortDescriptors = sortDescriptors
        self.fetchRequest = fetchRequest
        self.collectionView = collectionView
        super.init()
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func fetch(){
        try? fetchedResultsController.performFetch()
    }
    
    deinit {
        for operation in updateOperations { operation.cancel() }
        updateOperations.removeAll()
    }
}

// MARK: - UICollectionViewDataSource
extension FetchedCollectionViewDataSource: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let delegate = delegate else {
            return UICollectionViewCell()
        }
        
        let object = fetchedResultsController.object(at: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: delegate.collectionViewCellIdentifier(atIndex: indexPath, forObject: object), for: indexPath)
        
        delegate.collectionViewCellConfigure(cell: cell, atIndex: indexPath, forObject: object)

        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension FetchedCollectionViewDataSource: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let object = fetchedResultsController.object(at: indexPath)

        delegate?.collectionViewCellDidSelect(atIndex: indexPath, forObject: object)
    }
}

// MARK: - NSFetchedResultsControllerDelegate - inspired at https://stackoverflow.com/a/60044109/5479478
extension FetchedCollectionViewDataSource : NSFetchedResultsControllerDelegate{
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
            case .insert:
                updateOperations.append(BlockOperation(block: { [weak self] in
                    self?.collectionView?.insertItems(at: [newIndexPath!])
                }))
            case .delete:
                updateOperations.append(BlockOperation(block: { [weak self] in
                    self?.collectionView?.deleteItems(at: [indexPath!])
                }))
            case .update:
                updateOperations.append(BlockOperation(block: { [weak self] in
                    self?.collectionView?.reloadItems(at: [indexPath!])
                }))
            case .move:
                updateOperations.append(BlockOperation(block: { [weak self] in
                    self?.collectionView?.moveItem(at: indexPath!, to: newIndexPath!)
                }))
            @unknown default:
                break
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView?.performBatchUpdates({ () -> Void in
            for update: BlockOperation in self.updateOperations { update.start() }
        }, completion: { (finished) -> Void in self.updateOperations.removeAll() })
    }
}

// MARK: - FetchedCollectionViewDataSourceDelegate
protocol FetchedCollectionViewDataSourceDelegate : class{
    func collectionViewCellIdentifier(atIndex: IndexPath, forObject: NSManagedObject) -> String
    func collectionViewCellConfigure(cell: UICollectionViewCell, atIndex: IndexPath, forObject: NSManagedObject)
    func collectionViewCellDidSelect(atIndex: IndexPath, forObject: NSManagedObject)
}
