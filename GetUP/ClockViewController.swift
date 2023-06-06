	//
	//  ClockViewController.swift
	//  GetUP
	//
	//  Created by Doe on 3/2/18.
	//  Copyright © 2018 Doe. All rights reserved.
	//

import UIKit
import CustomAlert
import AVFoundation

@IBDesignable
class ClockViewController: UIViewController  {
	
		// MARK: Properties -
	@IBOutlet weak var setButton: RoundedButton!
	@IBOutlet weak var datePicker: UIDatePicker!
  @IBOutlet weak var clockLabel: UILabel!
   
	var alarmTVC = AlarmsTableViewController()
	
		// MARK: - Methods
	override func viewDidLoad() {
		super.viewDidLoad()
    let clockThread = Thread(target: self, selector: #selector(updateTimeLabel), object: nil)
    clockThread.start()
    
    clockLabel.text = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .short)
		Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTimeLabel), userInfo: nil, repeats: true)
		
		if let navVC = splitViewController?.viewControllers[0] as? UINavigationController , let alarm = navVC.viewControllers[0] as? AlarmsTableViewController {
			alarmTVC = alarm
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
  
  @objc func updateTimeLabel() {
    DispatchQueue.main.async(execute: {
      self.clockLabel.text = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .short)
    })
  }
	
	@IBAction func setAlarmButtonIsPressed(_ sender: UIButton) {
		let pickerDate = DateFormatter().formatPickerDate(pickerDate: datePicker)
		let datesFormExistingAlarms = alarmTVC.alarmArrayForAlarmTVC.map({$0.getAlarmTime()})
		if datesFormExistingAlarms.contains(pickerDate) == false {
			let newAlarm = Alarm(time: pickerDate)
      alarmTVC.alarmArrayForAlarmTVC.append(newAlarm)
      if alarmTVC.scheduler.createRequestAndSetAlarm(newAlarm) {
        alarmTVC.update()
        navigationController?.popViewController(animated: true)
      }
    }
  }
}

extension DateFormatter {
	func customFormattedDate(_ date : Date) -> Date {
    let dateComponents = Calendar.autoupdatingCurrent.dateComponents([.calendar,.year ,.month, .day , .hour , .minute ,.timeZone], from: date)
		let newDate = Calendar.autoupdatingCurrent.date(from: dateComponents)
		return newDate!
	}
  
	func formatPickerDate (pickerDate : UIDatePicker) -> Date {
		var newDate : Date
		if self.customFormattedDate(pickerDate.date) <= self.customFormattedDate(Date()){
			var dateComponents = Calendar.autoupdatingCurrent.dateComponents([.calendar, .year , .month , .day , .hour , .minute, .timeZone], from: pickerDate.date)
			dateComponents.day = dateComponents.day! + 1
			newDate = Calendar.autoupdatingCurrent.date(from: dateComponents)!
			return newDate
		}
		return self.customFormattedDate(pickerDate.date)
	}
	
	func print(_ date : Date) -> String {
		self.dateFormat = "h:mm a"
		return self.string(from: date)
	}
	
}
