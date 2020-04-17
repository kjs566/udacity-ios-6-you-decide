//
//  ProfileFlowCoordinator.swift
//  QuarantineWorkout
//
//  Created by Jan Skála on 17/04/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import Foundation

class ProfileFlowCoordinator: BaseFlowCoordinator{
    func showCalendar(vc: BaseController){
        performSegue(source: vc, segueIdentifier: "showCalendarSegue", flowAction: FlowPrepareData(vmFactory: { (_) in
            return CalendarViewModel()
        }))
    }
}
