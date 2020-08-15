//
//  File.swift
//  CoolCraig
//
//  Created by InfProjCourse2 on 12/5/19.
//  Copyright © 2019 InfProjCourse2. All rights reserved.
//

import Foundation

class reward {
  var rewardTitle: String?
  var rewardPoints: String?
    var claimedReward : Bool?
  
    //["goalTitle": Stay Focus on Task, "goalCategory": School, "goalPoints": 10]
    init(dictionary: [String : Any]) {
        guard let title = dictionary["rewardTitle"] as? String else {return}
        self.rewardTitle = title
        
        guard let points = dictionary["rewardPoints"] as? String else {return}
        self.rewardPoints = points
        
        guard let claimedReward = dictionary["claimed"] as? Bool else {return}
        self.claimedReward = claimedReward
            
    }
}

protocol rewardDocumentSerializable {
  init?(dictionary: [String: Any])
}
