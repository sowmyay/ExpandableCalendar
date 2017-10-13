//
//  CalendarContainerView.swift
//  CustomCalendar
//
//  Created by Sowmya Y on 14/03/17.
//  Copyright © 2017 Sowmya Y. All rights reserved.
//

import UIKit

protocol CalendarContainerDelegate: class {
    func selected(date:Date)
}

class CalendarContainerView: UIView, UIPageViewControllerDataSource, UIPageViewControllerDelegate, CalendarContentDelegate{

    var currentIndex = 0
    var numberOfPages = 0
    var dateChanged:Bool = false
    var calendarPage:UIPageViewController!
    
    weak var delegate:CalendarContainerDelegate?
    var selectedDate = CalendarHelper().getDate(string:CalendarHelper().getDateDetails(date: Date(), format: "yyyy-MM-dd"), format:"yyyy-MM-dd")
    
    var expandedView: Bool = true{
        didSet{
            if expandedView{
                numberOfPages = CalendarHelper().getNumberOfMonths() + 2 //inclusive
            }else{
                numberOfPages = CalendarHelper().getNumberOfWeeks()
            }
            
            let vc = self.calendarPage.viewControllers?.first as? CalendarContentVC
            vc?.expandedView = expandedView
            calendarPage.dataSource = nil
            calendarPage.dataSource  = self

        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        calendarPage.setViewControllers([getViewControllerAtIndex(0)], direction: .forward, animated: false, completion: nil)

    }
    
    //MARK:PageViewController DataSource
    
    func getViewControllerAtIndex(_ index: NSInteger) -> UIViewController
    {
        let contentVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CalendarVC") as! CalendarContentVC
        contentVC.pageIndex = index
        contentVC.expandedView = expandedView
        contentVC.selectedDate = selectedDate
        contentVC.delegate = self
        
        return contentVC
    }
    
    //MARK: PageController Delegate Methods
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var index: Int = 0
        index = (viewController as! CalendarContentVC).pageIndex
        
        if index == 0 {
            return nil
        }
        index -= 1
        
        return getViewControllerAtIndex(index)
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var index: Int = 0
        index = (viewController as! CalendarContentVC).pageIndex
        
        if (index == numberOfPages - 1) {
            return nil
        }
        index += 1
        
        return getViewControllerAtIndex(index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed{
            let currentView = pageViewController.viewControllers?.first as? CalendarContentVC
            if let index = currentView?.pageIndex{
                currentIndex = index
                if dateChanged{
                    currentView?.deSelectDate()
                    dateChanged = false
                }
            }
        }
    }
    
    func selectedDate(date: Date) {
        selectedDate = date
        self.delegate?.selected(date: date)
        dateChanged = true
    }
}
