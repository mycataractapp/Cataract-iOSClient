//
//  CalendarViewController.swift
//  Calendar
//
//  Created by Rose Choi on 5/25/18.
//  Copyright © 2018 Rose Choi. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarViewController : UIViewController, JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate
{
    private var _calendarView : JTAppleCalendarView!
    private var _dateFormatter : DateFormatter!
    
    var calendarView : JTAppleCalendarView
    {
        get
        {
            if (self._calendarView == nil)
            {
                self._calendarView = JTAppleCalendarView()
                self._calendarView.calendarDataSource = self
                self._calendarView.calendarDelegate = self
                self._calendarView.register(CustomCell.self, forCellWithReuseIdentifier: "CalendarCell")
                self._calendarView.backgroundColor = UIColor.white
            }
            
            let calendarView = self._calendarView!
            
            return calendarView
        }
    }
    
    var dateFormatter : DateFormatter
    {
        get
        {
            if (self._dateFormatter == nil)
            {
                self._dateFormatter = DateFormatter()
            }
            
            let dateFormatter = self._dateFormatter!
            
            return dateFormatter
        }
    }
    
    override func viewDidLoad()
    {
        self.calendarView.frame.size = self.view.frame.size
        self.view.addSubview(self.calendarView)
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters
    {
        self.dateFormatter.dateFormat = "yyyy MM dd"
        self.dateFormatter.timeZone = Calendar.current.timeZone
        self.dateFormatter.locale = Calendar.current.locale
        
        let startDate = dateFormatter.date(from: "2018 05 01")!
        let endDate = dateFormatter.date(from: "2018 06 30")!
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        
        return parameters
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell
    {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CustomCell
        cell.label.text = cellState.text
        cell.label.frame.size = cell.frame.size
        
//        let label = UILabel()
//        label.text = cellState.text
//        label.frame.size = cell.frame.size
    
//        cell.addSubview(label)
        
        print("cellForItem", indexPath.row)
        
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {}
}

class CustomCell : JTAppleCell
{
    private var _label : UILabel!
    
    var label : UILabel
    {
        get
        {
            if (self._label == nil)
            {
                self._label = UILabel()
                self.addSubview(self._label!)
            }
            
            let label = self._label!
            
            return label
        }
    }
}
