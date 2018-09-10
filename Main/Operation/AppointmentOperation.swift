//
//  AppointmentOperation.swift
//  Cataract
//
//  Created by Roseanne Choi on 6/11/18.
//  Copyright © 2018 Roseanne Choi. All rights reserved.
//

import Foundation

class AppointmentOperation : NSObject
{
    class GetAppointmentModelsQuery : DynamicQuery
    {
        override func execute() -> DynamicPromise
        {
            // Read from cache
            return DynamicPromise.resolve(value: nil)
        }
    }
    
//    func notification(appointmentModel: AppointmentModel)
//    {
//        let appointmentDate = self.datePickerController.viewModel.timeInterval
//        let date = Date(timeIntervalSince1970: appointmentDate)
//        let appointmentComponents = Calendar.current.dateComponents([Calendar.Component.year,
//                                                                     Calendar.Component.month,
//                                                                     Calendar.Component.day],
//                                                                    from: date)
//        let appointmentTime = self.timePickerController.viewModel.timeInterval
//        let time = Date(timeIntervalSince1970: appointmentTime - 1800)
//        let timeComponents = Calendar.current.dateComponents([Calendar.Component.hour,
//                                                              Calendar.Component.minute],
//                                                             from: time)
//        let appointmentDateFormatter = DateFormatter()
//        appointmentDateFormatter.dateStyle = .long
//        appointmentDateFormatter.timeStyle = .none
//        let appointmentDateToString = appointmentDateFormatter.string(from: date)
//
//        let appointmentTimeFormatter = DateFormatter()
//        appointmentTimeFormatter.dateStyle = .none
//        appointmentTimeFormatter.timeStyle = .short
//        let added = time + 1800
//        let appointmentTimeToString = appointmentTimeFormatter.string(from: added)
//
//        let content = UNMutableNotificationContent()
//        content.title = appointmentModel.title + " Appointment"
//        content.subtitle = "Appointment Time: " + appointmentDateToString + " at " + appointmentTimeToString
//        content.body = "Appointment in 30 minutes!"
//        content.sound = UNNotificationSound.default()
//
//        var dateComponents = DateComponents()
//        dateComponents.year = appointmentComponents.year
//        dateComponents.month = appointmentComponents.month
//        dateComponents.day = appointmentComponents.day
//        dateComponents.hour = timeComponents.hour
//        dateComponents.minute = timeComponents.minute
//
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
//        let request = UNNotificationRequest(identifier: appointmentModel.timeModel.identifier,
//                                            content: content,
//                                            trigger: trigger)
//
//        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
//    }
}
