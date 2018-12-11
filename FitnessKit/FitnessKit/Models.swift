//
//  Models.swift
//  FitnessKit
//
//  Created by Denis on 10/12/2018.
//  Copyright © 2018 Denis. All rights reserved.
//

import Foundation
import RealmSwift

class TrainingList: Object {
    @objc dynamic var name = ""
    @objc dynamic var startTime = ""
    @objc dynamic var endTime = ""
    @objc dynamic var teacher = ""
    @objc dynamic var place = ""
    @objc dynamic var descriptionTraining: String? = nil
    @objc dynamic var weekDay = 0
}

struct TrainingModel {
    
    let name: String
    let startTime: String
    let endTime: String
    let teacher: String
    let place: String
    let description: String
    let weekDay: Int
    
    init?(json: [String: Any]) {
        
        guard
            let name = json["name"] as? String,
            let startTime = json["startTime"] as? String,
            let endTime = json["endTime"] as? String,
            let teacher = json["teacher"] as? String,
            let place = json["place"] as? String,
            let description = json["description"] as? String,
            let weekDay = json["weekDay"] as? Int
            else {
                return nil
        }
        
        self.name = name
        self.startTime = startTime
        self.endTime = endTime
        self.teacher = teacher
        self.place = place
        self.description = description
        self.weekDay = weekDay
    }
}
