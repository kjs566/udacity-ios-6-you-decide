//
//  CoreDataResult.swift
//  VirtualTourist
//
//  Created by Jan Skála on 10/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation
import CoreData

typealias CoreDataResult<T: NSManagedObject> = AsyncResult<Array<T>>
