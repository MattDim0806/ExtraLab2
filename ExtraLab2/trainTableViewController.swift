//
//  trainTableViewController.swift
//  ExtraLab2
//
//  Created by 楊皓麟 on 2023/5/16.
//

import UIKit

class trainTableViewController: UIViewController {
    
    var startStation : String!
    var endStation : String!
    var trainNo : String!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewInit()
        titleLabel.text = trainNo + " 時刻表"
        // Do any additional setup after loading the view.
    }
    
    func tableViewInit(){
        let cellNIB = UINib(nibName: "trainTableViewCell", bundle: nil)
        tableView.register(cellNIB, forCellReuseIdentifier: "cell")
    }

}

extension trainTableViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section : Int) -> Int {
        return myTrainData[0].StopTimes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! trainTableViewCell
        let index = indexPath.row + 1
        cell.setCell(index: index, timeInfo: myTrainData[0].StopTimes[indexPath.row].ArrivalTime, stationName: myTrainData[0].StopTimes[indexPath.row].StationName.Zh_tw)
        if(myTrainData[0].StopTimes[indexPath.row].StationName.Zh_tw == startStation || myTrainData[0].StopTimes[indexPath.row].StationName.Zh_tw == endStation){
            cell.backgroundColor = UIColor.yellow // 设置起点单元格的背景颜色
        }
        else{
            cell.backgroundColor = UIColor.clear // 设置起点单元格的背景颜色
        }
        return cell
    }
}


extension trainTableViewController:UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
