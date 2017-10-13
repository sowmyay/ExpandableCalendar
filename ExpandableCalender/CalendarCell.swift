//
//  CalendarCell.swift
//  CustomCalendar
//
//  Created by Sowmya Y on 14/03/17.
//  Copyright © 2017 Sowmya Y. All rights reserved.
//

import UIKit

class CalendarCell: UICollectionViewCell {
    
    var isEnabled:Bool = true
    var isDateSelected: Bool = false
    @IBOutlet weak var buttonDate: UIButton!
    
    
    func config(weekDay: Int){
        self.buttonDate.setTitle(C.week[weekDay], for: .normal)
        self.buttonDate.setTitleColor(Color.weekLbl, for: .normal)
    }
    
    func config(date: Date, expandedView:Bool, isSelected:Bool, pageMonth:Int){
        
        var notThisMonth:Bool = false
        var passed:Bool = false
        
        let dateComponents = CalendarHelper().getdateComponents(date: date)
        
        if dateComponents.1! != pageMonth && expandedView{
            notThisMonth = true
        }
        
        if C.calendar.compare(date, to: Date(), toGranularity: .day).rawValue < 0 || C.calendar.compare(C.lastDate, to: date, toGranularity: .day).rawValue < 0{
            passed = true
        }
        
        buttonDate.setTitle("\(dateComponents.0!)", for: .normal)
        isDateSelected = isSelected
        
        var backgroundColor = Color.defaultBgd
        var titleColor = Color.enabled
        if notThisMonth || passed{
            titleColor = Color.disabled
            isEnabled = false
        }else {
            if isSelected{
                backgroundColor = Color.selectedBgd
            }
        }
        buttonDate.setTitleColor(titleColor, for: .normal)
        buttonDate.backgroundColor = backgroundColor
    }
    
}
