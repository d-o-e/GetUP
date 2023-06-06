	//
	//  Model.swift
	//  GetUP
	//
	//  Created by Doe on 3/7/18.
	//  Copyright © 2018 Doe. All rights reserved.
	//

import Foundation
import UIKit
import UserNotifications

	/// Alarm Scheduler Class
class AlarmScheduler : AlarmSchedulerProtocol {
	
	private var pendingNotificationsFromNotificationCenter = [UNNotificationRequest]()
	internal var scheduledNotificationIDs = [String]()
	internal var alarms = [Alarm]()
	let currentUserNotificationCenter = UNUserNotificationCenter.current()
	let appCalender = Calendar.autoupdatingCurrent
	
	init() {
		DispatchQueue.global().async {
			UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { self.getPendingAlarms($0) })
		}
	}
  
		/// Alarm Scheduler setting alarm
		///
		/// - Parameter alarm: Alarm object that you want to set
	internal func createRequestAndSetAlarm(_ alarm : Alarm) -> Bool {
    let alarmDates = alarms.map{$0.getAlarmTime()}
    if (scheduledNotificationIDs.contains(alarm.id)
        || alarmDates.contains(alarm.getAlarmTime())) {
      return false;
		} else {
      let content = UNMutableNotificationContent()
      content.title = "Wake UP!!!"
      content.body = "Think you're ready to get up?"
      content.sound = UNNotificationSound.default
      let dateinfo = appCalender.dateComponents([.year,.day,.hour,.minute,.month,.timeZone,.calendar], from: alarm.getAlarmTime())
      let trigger = UNCalendarNotificationTrigger(dateMatching: dateinfo, repeats: false)
      let request = UNNotificationRequest(identifier: alarm.id, content: content, trigger: trigger)
      currentUserNotificationCenter.add(request, withCompletionHandler:{
        $0 != nil ? print("There was a problem, couldn't add alarm \(String(describing: $0))" ) : self.scheduledNotificationIDs.append(request.identifier) })
//      print(request.identifier , (request.trigger as! UNCalendarNotificationTrigger).dateComponents.date!)
      alarms.append(alarm);
		}
    return true;
	}
	
		/// Remove notifications from Notification center
		///
		/// - Parameter alarm: alarm obj you want to remove from Notification center
	internal func removeRequest(_ alarm : [Alarm]) {
		let alarmIDs = alarm.map({$0.id})
		currentUserNotificationCenter.removePendingNotificationRequests(withIdentifiers: alarmIDs)
		for id in alarmIDs {
			if let index = scheduledNotificationIDs.firstIndex(of: id) {
				scheduledNotificationIDs.remove(at: index)
			}
		}
	}
	
	func getPendingAlarms(_ request : [UNNotificationRequest]) {
		request.forEach({alarms.append($0.getAlarmFromNotificationRequest())})
		alarms.sort()
		scheduledNotificationIDs.append(contentsOf: alarms.map({$0.id}))
//		print("scheduled alarms --\(scheduledNotificationIDs)")
	}
	
		/// Synchronizing Alarms
	internal func synchAlarms() {
		if alarms.map({$0.id}) != scheduledNotificationIDs {
			print("syncing")
			for alarm in alarms {
				if alarm.active == false {
          alarms.remove(at: alarms.firstIndex(of: alarm)!)
        }
        if !scheduledNotificationIDs.contains(alarm.id) {
          if createRequestAndSetAlarm(alarm) {
            print("New Alarms added")
            
          }
        }
      }
    }
		print(alarms.map({$0.id}))
	}
}

protocol AlarmSchedulerProtocol{
	var alarms : [Alarm] {get set}
	func synchAlarms()
	func removeRequest(_ alarm : [Alarm])
	func createRequestAndSetAlarm(_ alarm : Alarm) -> Bool
}

	//	- MARK: -
struct Alarm : Comparable{
	
	private var alarmTime: Date
	var active: Bool
	let id: String
	
	init(time newTime: Date) {
		alarmTime = newTime
		active = true
		id = UUID().uuidString
	}
	
	init(notification : UNNotificationRequest) {
		id = notification.identifier
		alarmTime = notification.getFiringDateFromRequest()
		active = true
	}
	
	func getAlarmTime() -> Date {
		return self.alarmTime
	}
	
	static func ==(lhs: Alarm, rhs: Alarm) -> Bool {
		if lhs.id == rhs.id {
			return true
		}
		return false
	}
	static func <(lhs: Alarm, rhs: Alarm) -> Bool {
		if lhs.getAlarmTime() < rhs.getAlarmTime() {
			return true
		}
		return false
	}
}

//  - MARK: - Extensions
extension UNNotificationRequest {
	
	func getFiringDateFromRequest() -> Date {
		let date = (self.trigger as! UNCalendarNotificationTrigger).dateComponents.date!
		return date
	}
	
	func getAlarmFromNotificationRequest() -> Alarm {
		return Alarm(notification: self)
	}
}
