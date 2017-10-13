//
//  CalendarConstants.swift
//  CustomCalendar
//
//  Created by Sowmya Y on 21/03/17.
//  Copyright © 2017 Sowmya Y. All rights reserved.
//

import Foundation
import UIKit

struct C {
    static let months = ["JANUARY", "FEBRUARY", "MARCH", "APRIL", "MAY", "JUNE", "JULY", "AUGUST", "SEPTEMBER", "OCTOBER", "NOVEMBER", "DECEMBER"]
    static let week = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
    static let calendar = NSCalendar.current
    
    static let monthNow = Int(CalendarHelper().getDateDetails(date:Date(), format: "MM"))
    static let weekNow = calendar.component(.weekOfYear, from: Date())
    static let firstWeekNo = calendar.component(.weekOfYear, from: CalendarHelper().startOfMonth(date: Date()))
    
    static var numberOfDays = 180
     
    static let lastDate = CalendarHelper().getLastDate()
    
}

struct Color {
    static var selectedBgd = UIColor.green
    static var defaultBgd = UIColor.clear
    static var enabled = UIColor.black
    static var weekLbl = UIColor.blue
    static var disabled = UIColor.lightGray
}
