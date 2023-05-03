//
//  timeTableViewController.swift
//  ExtraLab2
//
//  Created by 楊皓麟 on 2023/5/12.
//

import UIKit

class TrainInfo: Codable {
    var StopTimes: [StopTime]
}

class StopTime: Codable {
    var StopSequence: Int
    var StationID: String
    var StationName: StationName
    var ArrivalTime: String
    var DepartureTime: String
}

class StationName: Codable {
    var Zh_tw: String
    var En: String
}



class timeTableViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var startIndex: Int!
    var endIndex: Int!
    var accessToken1 : String!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewInit()
        titleLabel.text = String(format: "%@ - %@", myTimeTableData[0].OriginStopTime.StationName.Zh_tw, myTimeTableData[0].DestinationStopTime.StationName.Zh_tw)

        print(myTimeTableData.count)
    }

    func dismissViewController(){
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = .fade
        view.window?.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false, completion: nil)
    }
    
    func tableViewInit(){
        let cellNIB = UINib(nibName: "timeTableViewCell", bundle: nil)
        tableView.register(cellNIB, forCellReuseIdentifier: "cell")
    }
    
    func getTrainInfoApi(trainNo: String, startStation: String, endStation: String){
        print("查詢車次：" + trainNo)
        let url = URL(string: "https://tdx.transportdata.tw/api/basic/v2/Rail/THSR/DailyTimetable/Today/TrainNo/" + trainNo + "?%24top=30&%24format=JSON")!
        print(url)
        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken1!)", forHTTPHeaderField: "authorization")
        //request.setValue("Bearer eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJER2lKNFE5bFg4WldFajlNNEE2amFVNm9JOGJVQ3RYWGV6OFdZVzh3ZkhrIn0.eyJleHAiOjE2ODQxMzYzNzUsImlhdCI6MTY4NDA0OTk3NSwianRpIjoiMjNjN2U3NGMtZjBiNS00MjJiLTg4MWItM2Q4NTc4NWY5ZGZjIiwiaXNzIjoiaHR0cHM6Ly90ZHgudHJhbnNwb3J0ZGF0YS50dy9hdXRoL3JlYWxtcy9URFhDb25uZWN0Iiwic3ViIjoiMDkxYWFmODAtMGQ4ZC00N2RiLTg0ZDctMTQ4ZTAzMGViMTYwIiwidHlwIjoiQmVhcmVyIiwiYXpwIjoidDEwODM2MDEyNS1lYTE4NGEzMC1hZjFjLTQwZTQiLCJhY3IiOiIxIiwicmVhbG1fYWNjZXNzIjp7InJvbGVzIjpbInN0YXRpc3RpYyIsInByZW1pdW0iLCJtYWFzIiwiYWR2YW5jZWQiLCJ2YWxpZGF0b3IiLCJoaXN0b3JpY2FsIiwiYmFzaWMiXX0sInNjb3BlIjoicHJvZmlsZSBlbWFpbCIsInVzZXIiOiI5ZTQxZTFkYyJ9.QJS2-Hgi833c8CtoqsGRvYztVU736mtTgyKJCXJD18FFUrGa-Pr4QzKfAMOSycLfhx2lx3CbMN03MBcUktMQNH4yd-8mnCmY13fuB26Glqi87xVjlYP1xPb06ToZlw2cdYVpsMCgyHYtTftJeet0sILYs-9xtZPTuu2JhyBSHS3vf9B_H9d023slnnFydODDumVJZ9Onl5hW-GnW4VYIENzmD-A8366BTtIsfh39omYUM-zZe9EPo7vHUr_-mnYSfr0E0J6TUUq22o_sNPuYrcWu-r5V1bM4fZOCBG-i5BAwESvfi8GdbcDTVXfkzDaB0ATxZW8ds8h9RfDJsfGzRg", forHTTPHeaderField: "authorization")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request){ data, response, error in
            if(error != nil){
                print("發送失敗", error!.localizedDescription)
            }
            else{
                DispatchQueue.main.async {
                    myTrainData = try! JSONDecoder().decode([TrainInfo].self, from: data!)
                    let VC = trainTableViewController()
                    VC.startStation = startStation
                    VC.endStation = endStation
                    VC.trainNo = trainNo
                    self.present(VC, animated: true)
                }
            }
        }
        task.resume()
    }
    
}

extension timeTableViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section : Int) -> Int {
        return myTimeTableData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! timeTableViewCell
        cell.setCell(Direction: myTimeTableData[indexPath.row].DailyTrainInfo.Direction, TrainNo: myTimeTableData[indexPath.row].DailyTrainInfo.TrainNo, originArrivalTime: myTimeTableData[indexPath.row].OriginStopTime.ArrivalTime, DestinationArrivalTime: myTimeTableData[indexPath.row].DestinationStopTime.ArrivalTime)
        return cell
    }
}


extension timeTableViewController:UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        getTrainInfoApi(trainNo: myTimeTableData[indexPath.row].DailyTrainInfo.TrainNo, startStation: myTimeTableData[0].OriginStopTime.StationName.Zh_tw, endStation: myTimeTableData[0].DestinationStopTime.StationName.Zh_tw)
    }
}
