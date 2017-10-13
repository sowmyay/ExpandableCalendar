//
//  CalendarHelper.swift
//  CustomCalendar
//
//  Created by Sowmya Y on 30/03/17.
//  Copyright © 2017 Sowmya Y. All rights reserved.
//

import UIKit

class CalendarHelper: Any {

    let f = DateFormatter()
    
    func getDateDetails(date: Date, format: String) -> String{
        f.dateFormat = format
        return f.string(from: date)
    }
    
    func getDate(string:String, format:String) -> Date?{
        f.dateFormat = format
        return f.date(from: string)
    }
    
    func getLastDate() -> Date{
        var components = DateComponents()
        components.day = C.numberOfDays
        return C.calendar.date(byAdding: components, to: Date())!
    }
    
    func getNumberOfMonths() -> Int{
        return C.calendar.dateComponents([.month], from: Date(), to: C.lastDate).month ?? 0
    }
    
    func getNumberOfWeeks() -> Int{
        if C.calendar.component(.year, from: Date()) !=  C.calendar.component(.year, from: C.lastDate), let weekRange = C.calendar.range(of: .weekOfYear, in: .year, for: Date()){
            let preVWeeks = weekRange.count - C.calendar.component(.weekOfYear, from: Date())
            let nextWeeks = C.calendar.component(.weekOfYear, from: C.lastDate)
            
            return preVWeeks + nextWeeks
        }else{
            return C.calendar.dateComponents([.weekOfYear], from: Date(), to: C.lastDate).weekOfYear ?? 0
        }
    }
    
    func startOfMonth(date:Date) -> Date {
        return C.calendar.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: date)))!
    }
    
    func endOfMonth(date:Date) -> Date {
        return C.calendar.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth(date: date))!
    }
    
    func getFirstDate(ofMonthsFromNow:Int) -> Date?{
        var components = DateComponents()
        components.month = ofMonthsFromNow
        let date = self.startOfMonth(date: Date())
        return C.calendar.date(byAdding: components, to: date)
    }
    
    func getFirstDate(ofWeeksFromNow:Int) -> Date?{
        var components = DateComponents()
        components.day = ofWeeksFromNow * 7
        let day = self.getFirstDayOfWeek(day: Date())
        
        return C.calendar.date(byAdding: components, to: day!)
    }
    
    
    func getWeekday(ofDate:Date) -> Int?{
        let firstDay = C.calendar.dateComponents([.weekday], from: ofDate)
        return firstDay.weekday
    }
    
    func getdateComponents(date:Date) -> (Int?, Int?, Int?){
        let year = C.calendar.component(.year, from: date)
        let month = C.calendar.component(.month, from: date)
        let day = C.calendar.component(.day, from: date)
        return (day, month, year)
    }
    
    func getFirstDayOfWeek(day:Date) -> Date?{
        let firstWeekDay = CalendarHelper().getWeekday(ofDate: day)
        return C.calendar.date(byAdding: .day, value: -1 * firstWeekDay! + 1, to: day)
    }

}
