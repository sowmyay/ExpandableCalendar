//
//  CalendarVC.swift
//  CustomCalendar
//
//  Created by Sowmya Y on 15/03/17.
//  Copyright © 2017 Sowmya Y. All rights reserved.
//

import UIKit

protocol CalendarDelegate: class {
    func expandTouched(height: CGFloat)
    func selected(date:Date)
}
class CalendarVC: UIViewController, CalendarContainerDelegate {

    weak var delegate: CalendarDelegate?
    @IBOutlet weak var containerHeight: NSLayoutConstraint!
    @IBOutlet weak var containerView: CalendarContainerView!
    
    var expandedView:Bool = true{
        didSet{
           contHeight  = expandedView ? 350:120
        }
    }
    
    @IBInspectable var contHeight: CGFloat = 350 {
        didSet {
            if self.isViewLoaded{
                containerHeight.constant = contHeight
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate?.expandTouched(height: contHeight + 60)
    }
    
    @IBAction func expandTouch(_ sender: Any) {
        expandedView = !expandedView
        containerView.expandedView = expandedView
        self.delegate?.expandTouched(height: contHeight + 60)
    }
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? UIPageViewController
            , segue.identifier == "EmbedPageSegue" {
            containerView.calendarPage = vc
            containerView.delegate = self
            containerView.expandedView = expandedView
            containerView.calendarPage.delegate = containerView.self
            containerView.calendarPage.dataSource = containerView.self
        }
    }
    
    func setParameters(expandedView:Bool, minNumberOfDays:Int, selectedBackgroundColor:UIColor, defaultBackgroundColor:UIColor, enabledDateColor:UIColor, disabledDateColor:UIColor, weekLblColor:UIColor){
        self.expandedView = expandedView
        C.numberOfDays = minNumberOfDays
        Color.selectedBgd = selectedBackgroundColor
        Color.defaultBgd = defaultBackgroundColor
        Color.enabled = enabledDateColor
        Color.disabled = disabledDateColor
        Color.weekLbl = weekLblColor
    }
    
    func selected(date:Date){
        self.delegate?.selected(date: date)
    }


}
