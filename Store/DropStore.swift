//
//  DropStore.swift
//  Cataract
//
//  Created by Roseanne Choi on 6/9/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import Foundation
import SwiftyJSON
import CareKit
import UserNotifications

class DropStore : DynamicStore<DropModel>, OCKCarePlanStoreDelegate, OCKCareCardViewControllerDelegate
{
    private var _store : OCKCarePlanStore!
    
    override var identifier: String?
    {
        get
        {
            return "DropStore"
        }
    }

    var store : OCKCarePlanStore
    {
        get
        {
            if (self._store == nil)
            {
                let path = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)[0].appendingPathComponent("DropStore").path
                let url = URL(fileURLWithPath: path)

                if !FileManager.default.fileExists(atPath: url.path)
                {
                    try! FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
                }

                self._store = OCKCarePlanStore(persistenceDirectoryURL: url)
                self._store.delegate = self
            }

            let store = self._store!

            return store
        }
    }
    
    func notification(dropModel: DropModel, startDateController: DatePickerController)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        
        let startDateTimeInterval = startDateController.viewModel.timeInterval
        let startDate = Date(timeIntervalSince1970: startDateTimeInterval)
        var startDateComponents = Calendar.current.dateComponents([Calendar.Component.year,
                                                                   Calendar.Component.month,
                                                                   Calendar.Component.day],
                                                                  from: startDate)
        for timeModel in dropModel.timeModels
        {
            let dropTime = Date(timeIntervalSince1970: timeModel.timeInterval)
            var timeComponents = Calendar.current.dateComponents([Calendar.Component.hour,
                                                                  Calendar.Component.minute],
                                                                 from: dropTime)
            var dateComponents = DateComponents()
            dateComponents.year = startDateComponents.year
            dateComponents.month = startDateComponents.month
            dateComponents.day = startDateComponents.day
            dateComponents.hour = timeComponents.hour
            dateComponents.minute = timeComponents.minute
            
            let content = UNMutableNotificationContent()
            let dateString = dateFormatter.string(from: dropTime)
            content.title = dropModel.title
            content.body = "Time is " + dateString + ", take " + content.title + "."
            content.sound = UNNotificationSound.default()
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            let request = UNNotificationRequest(identifier: timeModel.identifier,
                                                content: content,
                                                trigger: trigger)
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
    }
    
    override func asyncGet(count: Int, info: [String : Any]?, isNetworkEnabled: Bool) -> DynamicPromise
    {
        let promise = DynamicPromise
        { (resolve, reject) in
            
            let dropModels = self.decodeModels()
            print(dropModels, "BB")
            
            if (dropModels != nil)
            {
                resolve(dropModels)
            }
            else
            {
                reject(DynamicPromiseError("No Local"))
            }
        }
        
        return promise
    }
    
    override func asyncAdd(_ model: DropModel, isNetworkEnabled: Bool) -> DynamicPromise
    {
        let promise = DynamicPromise
        { (resolve, reject) in
            
            self.store.add(model.activity, completion:
            { (isCompleted, error) in
                
                print(model, "FF")
                DispatchQueue.main.async
                {
                    print(model, "AA")
                    resolve(model)
                    print(model, "BB")
                }
            })
        }
        
        return promise
    }
    
    func removeDrop(activity: OCKCarePlanActivity)
    {
        self.store.remove(activity)
        { (isCompleted, error) in
            
            self.removeNotification()
        }
    }
    
    func removeNotification()
    {
        let dropModels = self.decodeModels()
        
        for dropModel in dropModels!
        {
            var identifiers = [String]()
            
            for timeModel in dropModel.timeModels
            {
                identifiers.append(timeModel.identifier)
            }
            
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        }
    }
    
//    override func asyncGet(count: Int, info: [String : Any]?, isNetworkEnabled: Bool) -> DynamicPromise
//    {
//        let promise = DynamicPromise
//        { (resolve, reject) in
//
//            let models = self.decodeModels()
//
//            if (models != nil)
//            {
//                resolve(models)
//            }
//            else
//            {
//                reject(DynamicPromiseError("Something went wrong"))
//            }
//        }
//
//        return promise
//    }
}


