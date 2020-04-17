//
//  ObservableUseCase.swift
//  QuarantineWorkout
//
//  Created by Jan Skála on 16/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation

protocol ObservableUseCase: UseCase where
    RepositoryResult == ObservableProperty<ObservableType>,
    Result == ObservableProperty<ObservableType>{
        associatedtype ObservableType
}
