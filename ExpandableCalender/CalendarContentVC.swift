//
//  CalendarVC.swift
//  CustomCalendar
//
//  Created by Sowmya Y on 14/03/17.
//  Copyright © 2017 Sowmya Y. All rights reserved.
//

import UIKit

protocol CalendarContentDelegate: class {
    func selectedDate(date:Date)
}
class CalendarContentVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var calendarView: UICollectionView!
    
    var pageIndex:Int!
    var datesArray = [[Date]]()
    var selectedDate:Date? = nil
    var selectedIndex:IndexPath? = nil
    weak var delegate: CalendarContentDelegate?

    var month:Int!{
        didSet{
            print(C.months[month - 1])
            monthLabel.text = "\(C.months[month - 1]) \(year)"
        }
    }
    var year:Int = 2017
    
    var expandedView: Bool = false{
        didSet{
            if self.isViewLoaded{
                if !expandedView{
                    var section = 0
                    if let i = selectedIndex{
                        section = i.section - 1
                    }
                    if let firstDate = datesArray[section].first{
                        year = C.calendar.component(.year, from: firstDate)
                        if C.calendar.component(.year, from: Date()) !=  C.calendar.component(.year, from: firstDate), let weekRange = C.calendar.range(of: .weekOfYear, in: .year, for: Date()){
                            let preVWeeks = weekRange.count - C.calendar.component(.weekOfYear, from: Date())
                            let nextWeeks = C.calendar.component(.weekOfYear, from: firstDate)
                            
                            pageIndex = preVWeeks + nextWeeks
                        }else{
                            let weekNo = C.calendar.component(.weekOfYear, from: firstDate)
                            pageIndex = weekNo - C.weekNow
                        }
                    }
                    loadWeek()
                }else{
                    pageIndex = month - C.monthNow!
                    loadCalendar()
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if expandedView{
            loadCalendar()
        }else{
            loadWeek()
        }
        
    }
    
    //MARK:- CollectionView DataSource
    
    func loadWeek(){
    
        let firstDate = CalendarHelper().getFirstDate(ofWeeksFromNow: pageIndex)
        datesArray = [[Date]]()
        month = C.calendar.component(.month, from: firstDate!)
        fillDates(firstDay: firstDate!, firstWeekDay: 1)
        calendarView.reloadData()
    }
    
    func loadCalendar(){

        let firstDate = CalendarHelper().getFirstDate(ofMonthsFromNow: pageIndex)
        datesArray = [[Date]]()
        month = C.calendar.component(.month, from: firstDate!)
        let firstWeekDay = CalendarHelper().getWeekday(ofDate: firstDate!)
        fillDates(firstDay: firstDate!, firstWeekDay: firstWeekDay!)
        calendarView.reloadData()
    }

    func fillDates(firstDay:Date, firstWeekDay:Int){
        var i:Int = 0
        var count = 7
        if !expandedView{
            count = 1
        }
        while i < count {
            var first = firstDay
            if firstWeekDay != 1{
                first = C.calendar.date(byAdding: .day, value: -1 * firstWeekDay + 7*i + 1, to: firstDay)! // First day of each week
            }else{
                first = C.calendar.date(byAdding: .day, value: 7*i, to: firstDay)! // First day of each week
            }
            
            let week = fillDatesForWeek(firstDay: first)
            i += 1
            datesArray.append(week)
        }
        
    }
    
    func fillDatesForWeek(firstDay:Date) -> [Date]{
        var weekDates = [Date]()
        weekDates.append(firstDay)
        var prevDay = firstDay
        var i:Int = 1
        
        while i<7 {
            let nextDay = C.calendar.date(byAdding: .day, value: 1, to: prevDay)
            prevDay = nextDay!
            
            weekDates.append(nextDay!)
            i += 1
        }
        return weekDates
    }
    
    //MARK:- CollectionView Delegate Methods

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if expandedView{
            return 7
        }else{
            return 2
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width/7.0, height: 44)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var selectedCell = false
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: indexPath.section == 0 ? "WeekdayCell" : "CalendarCell" , for: indexPath) as! CalendarCell

        if indexPath.section != 0{
                
                let sectionArray = datesArray[indexPath.section - 1]
                let date = sectionArray[indexPath.row]
                
                if let sdate = selectedDate{
                    if C.calendar.compare(sdate, to: date, toGranularity: .day) == .orderedSame{
                        selectedCell = true
                        selectedIndex = indexPath
                    }
                }
            cell.config(date: date, expandedView: expandedView, isSelected: selectedCell, pageMonth: month)
            
        }else{
            cell.config(weekDay: indexPath.item)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard indexPath.section != 0, let selectedCell = collectionView.cellForItem(at: indexPath) as? CalendarCell, selectedCell.isEnabled else{
            print("Selection Disabled")
            return
        }
        
        self.deSelectDate(indexPath: indexPath)
        
        let sectionArray = datesArray[indexPath.section - 1]
        let date = sectionArray[indexPath.row]

        selectedCell.buttonDate.backgroundColor = Color.selectedBgd
        self.delegate?.selectedDate(date: date)
        selectedDate = date
        
    }
    
    func deSelectDate(indexPath:IndexPath? = nil){
        if let s = selectedIndex{
            let prevCell = calendarView.cellForItem(at: s) as? CalendarCell
            prevCell?.buttonDate.backgroundColor = Color.defaultBgd
        }
        selectedIndex = indexPath
    }
}
