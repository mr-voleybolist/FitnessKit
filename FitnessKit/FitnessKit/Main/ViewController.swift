//
//  ViewController.swift
//  FitnessKit
//
//  Created by Denis on 10/12/2018.
//  Copyright © 2018 Denis. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var trainings: Results<TrainingList>!
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !isAppAlreadyLaunchedOnce() {
            downloadData()
        }
        trainings = realm.objects(TrainingList.self)
    }
    
    func downloadData() {
        request("https://sample.fitnesskit-admin.ru/schedule/get_group_lessons_v2/4/").responseJSON { responseJSON in
            
            switch responseJSON.result {
            case .success(let value):
                
                guard let jsonArray = value as? Array<[String: Any]> else { return }
                
                for jsonObject in jsonArray {
                    guard let training = TrainingModel(json: jsonObject) else { return }
                    self.writeInBase(name: training.name, startTime: training.startTime, endTime: training.startTime, teacher: training.teacher, place: training.place, descriptionTraining: training.description, weekDay: training.weekDay)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func isAppAlreadyLaunchedOnce()->Bool{
        let defaults = UserDefaults.standard
        
        if let isAppAlreadyLaunchedOnce = defaults.string(forKey: "isAppAlreadyLaunchedOnce"){
            print("App already launched : \(isAppAlreadyLaunchedOnce)")
            return true
        }else{
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            print("App launched first time")
            return false
        }
    }
    
    func writeInBase(name: String, startTime: String, endTime: String, teacher: String, place: String, descriptionTraining: String, weekDay: Int) {
        let trainingList = TrainingList()
        trainingList.name = name
        trainingList.startTime = startTime
        trainingList.endTime = endTime
        trainingList.teacher = teacher
        trainingList.place = place
        trainingList.descriptionTraining = descriptionTraining
        trainingList.weekDay = weekDay
        
        try! realm.write {
            realm.add(trainingList)
        }
    }
 
    func getNameDay(weekDay:Int) -> String {
        switch weekDay {
        case 1:
            return "Понедельник"
        case 2:
            return "Вторник"
        case 3:
            return "Среда"
        case 4:
            return "Четверг"
        case 5:
            return "Пятница"
        case 6:
            return "Суббота"
        case 7:
            return "Воскресенье"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if trainings.count != 0 {
            return trainings.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        let training = trainings[indexPath.row]
        cell.weekDayLabel.textColor = .blue
        cell.weekDayLabel.text = "\(getNameDay(weekDay: training.weekDay))"
        cell.nameLabel.text = training.name
        cell.startTimeLabel.text = training.startTime
        cell.endTimeLabel.text = training.endTime
        cell.teacherLabel.text = training.teacher
        cell.placeLabel.text = training.place
        cell.descriptionLabel.text = training.descriptionTraining
        return cell
    }

}

