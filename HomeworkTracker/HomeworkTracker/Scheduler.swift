//
//  Scheduler.swift
//  HomeworkTracker
//
//  Created by user157777 on 9/22/19.
//  Copyright © 2019 user157777. All rights reserved.
//

import Foundation

class Scheduler {
    var events: [Event]
    init(withEvents events:[Event]) {
        self.events = events
    }
    
    func scheduleHomework (homeworkStartTime: Date, homeworkEndTime: Date, scheduleStartTime: Date) {
        var newEventStartTime: Date? = nil
        var newEventEndTime: Date? = nil
        
        var newEventStartTime1: Date? = nil
        var newEventStartTime2: Date? = nil
        var newEventEndTime1: Date? = nil
        var newEventEndTime2: Date? = nil
        let numOfEvents = events.count
        for x in 0...(numOfEvents-1){
            let event = events[x]
            let startTimeInterfere = isTimeInRange(comparedTime: homeworkStartTime, startTime: event.eventTime!, endTime: (event.eventTime!+event.eventDuration), homeworkStart: homeworkStartTime, homeworkEnd: homeworkEndTime)
            let eventInside = isTimeRangeInTimeRange(startTimeInside: event.eventTime!, endTimeInside: (event.eventTime!+event.eventDuration), startTimeOutside: homeworkStartTime, endTimeOutside: homeworkEndTime)
            let endTimeInterfere = isTimeInRange(comparedTime: homeworkEndTime, startTime: event.eventTime!, endTime: (event.eventTime!+event.eventDuration), homeworkStart: homeworkStart, homeworkEnd: homeworkEnd)
            let homeworkInside = isTimeRangeInTimeRange(startTimeInside: homeworkStart, endTimeInside: homeworkEnd, startTimeOutside: event.eventTime!, endTimeOutside: (event.eventTime!+event.eventDuration))
            if startTimeInterfere == true || homeworkInside == true{
                newEventStartTime = (event.eventTime! + event.eventDuration)
                newEventEndTime = (newEventStartTime! + homeworkDuration)
            }
            if endTimeInterfere  == true || eventInside == true {
                newEventStartTime1 = homeworkStart
                newEventEndTime1 = event.eventTime!
                let timeSpent = Calendar.current.dateComponents([.second], from: homeworkStart, to: newEventEndTime1!).minute
                newEventStartTime2 = (event.eventTime! + event.eventDuration)
                let timeSpentDouble = Double(timeSpent!)
                let timeLeft = (homeworkDuration - timeSpentDouble)
                newEventEndTime2 = (newEventStartTime2! + timeLeft)
                
            }
        }
        return (newEventStartTime, newEventEndTime, newEventStartTime1, newEventEndTime1, newEventStartTime2, newEventEndTime2)
        
    }
}
