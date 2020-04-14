//
//  GeocodeLocation.swift
//  VirtualTourist
//
//  Created by Jan Skála on 07/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation
import CoreLocation

class GeocodeResult{
    init(forAddress: String) {
        self.forAddress = forAddress
    }
    
    var forAddress: String
    var state: AsyncResult<[CLPlacemark]?> = .loading
    
    var canceled = false
    
    func setError(_ error: Error?){
        self.state = .error(error)
    }
    
    func setSuccess(_ places: [CLPlacemark]?){
        self.state = .success(places)
    }
    
    func setCanceled(){
        canceled = true
    }
    
    func isCanceled() -> Bool{
        return canceled
    }
}

class GeocodeLocationPropety: ObservableProperty<GeocodeResult>{
    var currentResult: GeocodeResult? = nil
    
    func load(address: String){
        currentResult?.setCanceled()
        let result = GeocodeResult(forAddress: address)
        currentResult = result
        setValue(result)
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (places, error) in
            if let error = error {
                result.setError(error)
            }else {
                result.setSuccess(places)
            }
            if !result.isCanceled(){
                self.setValue(result)
            }
        }
    }

}
