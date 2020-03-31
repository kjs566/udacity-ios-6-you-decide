//
//  AppDelegate.swift
//  OnTheMap
//
//  Created by Jan Skála on 29/03/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    let parseApiClient = ParseApiClient()
    
    var sharedData : [PinPost] = []
    
    func deletePost(_ post: PinPost) -> Int?{
        if let index = sharedData.firstIndex(of: post){
            sharedData.remove(at: index)
            return index
        }
        return nil
    }
    
    func replacePost(oldMeme: PinPost, newMeme: PinPost){
        if let deletedIndex = deletePost(oldMeme){
            sharedData.insert(newMeme, at: deletedIndex)
        }
    }
    
    func addPost(_ post: PinPost){
        sharedData.append(post)
    }
}

