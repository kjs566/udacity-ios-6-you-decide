//
//  PhotoCollectionDownloader.swift
//  VirtualTourist
//
//  Created by Jan Skála on 13/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation
import CoreData

class PhotoCollectionDownloader{
    let propertyObserver = PropertyObserver()
    
    private var expectedPhotosResults = 20
    private var receivedPhotosResults = 0
    
    private let pin: Pin
    
    let state = ObservableProperty<AsyncResult<Void>>()
    var downloadTasks = [URLSessionTask]()
    
    init(pin: Pin) {
        self.pin = pin
        if pin.isNew{
            startApiLoading(page: pin.flickerPage)
        }else {
            state.setValue(.success(nil))
        }
    }

    func startApiLoading(page: Int32){
        cancelAllRequests()
        
        receivedPhotosResults = 0
        state.setValue(.loading)
        let photosListLoadingProperty = FlickerApi.shared.getSearchPhotosProperty(lon: pin.lon, lat: pin.lat, page: Int(page))
        
        DataController.shared.updateBackground(id: pin.objectID, updater: { (pin: Pin) in
            pin.flickerPage = page
            pin.isNew = true
        }, errorHandler: { error in
            self.setError(error)
        })
        
        propertyObserver.observeProperty(photosListLoadingProperty) { (result) in
            guard let result = result else { return }
            result.handle(success: { (response) in
                self.savePhotosListAndDownload(response)
            }, error: { error in
                self.state.setValue(.error(error))
            })
        }
    }

    func savePhotosListAndDownload(_ response: PhotosResponse?){
        guard let photos = response?.photos.photo else { return }
        
        expectedPhotosResults = photos.count
        for photoMeta in photos{
            let objectId = DataController.shared.createAndSave(initializer: { (photo: Photo) in
                photo.pin = self.pin
                photo.isNew = true
                photo.photoId = photoMeta.id
            }, errorHandler:  { (error) in
                self.setError(error)
            })
            
            if let objectId = objectId {
                downloadPhoto(objectId: objectId, photoId: photoMeta.id!)
            }else{
                setError(nil)
            }
        }
    }

    func downloadPhoto(objectId: NSManagedObjectID, photoId: String){
        let downloadTask = FlickerApi.shared.getSizesRequest(photoId: photoId).execute { (sizes, error) in
            if error != nil{
                self.setPhotoLoadingError(objectId, photoId)
            }else{
                self.downloadImage(objectId: objectId, id: photoId, sizes: sizes)
            }
        }
        downloadTasks.append(downloadTask)
    }

    func setPhotoLoadingError(_ objectId: NSManagedObjectID?, _ photoId: String?){
        if let objectId = objectId {
            DataController.shared.updateBackground(id: objectId, updater: { (photo: Photo) in
                photo.error = true
            }, errorHandler: { error in
                self.setError(error)
            })
        }
        
        receivedPhotosResults += 1
        checkResults()
    }

    func setPhotoLoadingSuccess(objectId: NSManagedObjectID, data: Data){
        DataController.shared.updateBackground(id: objectId, updater: {(photo: Photo) in
            photo.isNew = false
            photo.image = data
            photo.error = false
        }, errorHandler: { error in
            self.setError(error)
        })
        
        receivedPhotosResults += 1
        checkResults()
    }

    func downloadImage(objectId: NSManagedObjectID, id: String, sizes: SizesResponse?){
        if let size = sizes?.sizes?.size.first(where: { (size) -> Bool in
            size.width > 100
        }){
            BaseApi.rawRequest(url: size.source, callback: {
                (data, error) in
                if error != nil{
                    self.setPhotoLoadingError(objectId, id)
                }else{
                    self.setPhotoLoadingSuccess(objectId: objectId, data: data!)
                }
            })
        }else{
            setPhotoLoadingError(objectId, id)
        }
    }

    func loadNextPage(){
        let page = pin.flickerPage + 1
        DataController.shared.update(id: pin.objectID, updater: { (pin: Pin) in
            pin.flickerPage = page
            pin.isNew = true
            pin.photos = []
        }, errorHandler:  nil)
        startApiLoading(page: page)
    }
    
    func setError(_ error: Error?){
        state.setValue(.error(error))
        cancelAllRequests()
    }

    func cancelAllRequests(){
        for task in downloadTasks{
            task.cancel()
        }
        downloadTasks = []
    }
    
    func checkResults(){
        let isError = state.getValue()?.isError() ?? false
        if !isError && receivedPhotosResults == expectedPhotosResults{
            saveCollectionState()
            state.setValue(.success(nil))
        }
    }
    
    func saveCollectionState(){
        DataController.shared.updateBackground(id: pin.objectID, updater: {(pin: Pin) in
            pin.isNew = false
        }, errorHandler: { error in
            self.setError(error)
        })
    }
    
    deinit {
        cancelAllRequests()
        propertyObserver.dispose()
    }
}
