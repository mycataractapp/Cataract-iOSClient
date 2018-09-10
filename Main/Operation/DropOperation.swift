//
//  DropOperation.swift
//  Cataract
//
//  Created by Roseanne Choi on 6/9/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import Foundation
import CareKit
import UserNotifications

class DropOperation : NSObject
{
    class GetDropModelsQuery : DynamicQuery
    {
        override func execute() -> DynamicPromise
        {
            // Read from cache
            return DynamicPromise.resolve(value: nil)
        }
    }
    
    class Mutation : DynamicMutation, OCKCarePlanStoreDelegate, OCKCareCardViewControllerDelegate
    {
        private var _ockCarePlanStore : OCKCarePlanStore!
        
        var ockCarePlanStore : OCKCarePlanStore
        {
            get
            {
                if (self._ockCarePlanStore == nil)
                {
                    let path = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)[0].appendingPathComponent("OCKCarePlanStore").path
                    let url = URL(fileURLWithPath: path)
                    
                    if !FileManager.default.fileExists(atPath: url.path)
                    {
                        try! FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
                    }
                    
                    self._ockCarePlanStore = OCKCarePlanStore(persistenceDirectoryURL: url)
                    self._ockCarePlanStore.delegate = self
                }
                
                let ockCarePlanStore = self._ockCarePlanStore!
                
                return ockCarePlanStore
            }
        }
        
        override func execute<ModelType>(operation: DynamicMutation.Operation, models: [ModelType]) -> DynamicPromise where ModelType : DropModel
        {
            return DynamicPromise.resolve(value: nil)
        }
        
        private func add(dropModel: DropModel) -> DynamicPromise
        {
            let promise = DynamicPromise.resolve(value: nil)
//            .then
//            { (value) -> Any? in
//
//                self.store.add(model.activity)
//                { (isCompleted, error) in
//
//                    DispatchQueue.main.async
//                    {
//
//                        let dateFormatter = DateFormatter()
//                        dateFormatter.dateStyle = .none
//                        dateFormatter.timeStyle = .short
//
//                        let startDateTimeInterval = startDateController.viewModel.timeInterval
//                        let startDate = Date(timeIntervalSince1970: startDateTimeInterval)
//                        var startDateComponents = Calendar.current.dateComponents([Calendar.Component.year,
//                                                                                   Calendar.Component.month,
//                                                                                   Calendar.Component.day],
//                                                                                  from: startDate)
//                        for timeModel in dropModel.timeModels
//                        {
//                            let dropTime = Date(timeIntervalSince1970: timeModel.timeInterval)
//                            var timeComponents = Calendar.current.dateComponents([Calendar.Component.hour,
//                                                                                  Calendar.Component.minute],
//                                                                                 from: dropTime)
//                            var dateComponents = DateComponents()
//                            dateComponents.year = startDateComponents.year
//                            dateComponents.month = startDateComponents.month
//                            dateComponents.day = startDateComponents.day
//                            dateComponents.hour = timeComponents.hour
//                            dateComponents.minute = timeComponents.minute
//
//                            let content = UNMutableNotificationContent()
//                            let dateString = dateFormatter.string(from: dropTime)
//                            content.title = dropModel.title
//                            content.body = "Time is " + dateString + ", take " + content.title + "."
//                            content.sound = UNNotificationSound.default()
//
//                            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
//
//                            let request = UNNotificationRequest(identifier: timeModel.identifier,
//                                                                content: content,
//                                                                trigger: trigger)
//
//                            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
//                        }
//                    }
//                }
//            }
            
            return promise
        }
        
        private func remove(dropModel: DropModel) -> DynamicPromise
        {
            let promise = DynamicPromise.resolve(value: dropModel)
//            .then
//            { (value) -> Any? in
//                
//                self.store.remove(dropModel.ockCarePlanActivity)
//                { (isCompleted, error) in
//                    
//                    let dropModels = self.decodeModels()
//                    
//                    for dropModel in dropModels!
//                    {
//                        var identifiers = [String]()
//                        
//                        for timeModel in dropModel.timeModels
//                        {
//                            identifiers.append(timeModel.identifier)
//                        }
//                        
//                        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
//                    }
//                }
//            }
            
            return promise
        }
    }
}


