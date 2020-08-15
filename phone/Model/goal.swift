//
//  goals.swift
//  CoolCraig
//
//  Created by InfProjCourse2 on 12/2/19.
//  Copyright © 2019 InfProjCourse2. All rights reserved.
//

import Foundation

class goal {
  var category: String?
  var title: String?
  var points: String?
    var completedGoal : Bool?
    var beginTime: Date?
    var endTime: Date?
  
    //["goalTitle": Stay Focus on Task, "goalCategory": School, "goalPoints": 10]
    init(dictionary: [String : Any]) {
        let category = dictionary["goalCategory"] as? String
        self.category = category
        
        guard let title = dictionary["goalTitle"] as? String else {return}
        self.title = title
        
        guard let points = dictionary["goalPoints"] as? String else {return}
        self.points = points
        
        guard let completedGoal = dictionary["isCompleted"] as? Bool else {return}
        self.completedGoal = completedGoal
        
        guard let beginTime = dictionary["beginTimeOfGoal"] as? Date else {return}
        self.beginTime = beginTime

        guard let endTime = dictionary["endTimeOfGoal"] as? Date else {return}
        self.endTime = endTime

        
            
    }
}

protocol DocumentSerializable {
  init?(dictionary: [String: Any])
}
