//
//  restaurantTableViewController.swift
//  ExtraLab2
//
//  Created by 楊皓麟 on 2023/5/20.
//

import UIKit
import CoreLocation
import Toast
class restaurantTableViewController: UIViewController {
    var nearbyRestaurant : [Int] = []
    var lat : Double!
    var lng : Double!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewInit()
        // Do any additional setup after loading the view.
    }
    func tableViewInit(){
        let cellNIB = UINib(nibName: "restaurantTableViewCell", bundle: nil)
        tableView.register(cellNIB, forCellReuseIdentifier: "cell")
        print("附近餐廳陣列")
        print(nearbyRestaurant)
        view.makeToast("資料下載中，請稍等")
    }
    
    
}


extension restaurantTableViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section : Int) -> Int{
    
        return myRestaurantData.results.content.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! restaurantTableViewCell
        
        if indexPath.row <= 15 {
            let imageStr = myRestaurantData.results.content[indexPath.row].photo
            let restaurantName = myRestaurantData.results.content[indexPath.row].name
            let vicinity = myRestaurantData.results.content[indexPath.row].vicinity
            let rate = myRestaurantData.results.content[indexPath.row].rating
            let reviewsNumber = myRestaurantData.results.content[indexPath.row].reviewsNumber
            
            let coordinate1 = CLLocation(latitude: myRestaurantData.results.content[indexPath.row].lat, longitude: myRestaurantData.results.content[indexPath.row].lng) // 餐厅的经纬度
            let coordinate2 = CLLocation(latitude: lat, longitude: lng) // 用户的经纬度
            let distanceInMeters = coordinate1.distance(from: coordinate2) // 计算两点间的距离（单位：米）
            let distanceInKilometers = distanceInMeters / 1000.0 // 将距离转换为公里
            let formattedDistance = String(format: "%.2f", distanceInKilometers)
            
            if let imageURL = URL(string: imageStr) {
                DispatchQueue.global().async {
                    if let imageData = try? Data(contentsOf: imageURL) {
                        DispatchQueue.main.async {
                            if let image = UIImage(data: imageData) {
                                cell.setCell(image: image, restaurantName: restaurantName, vicinity: vicinity, distance: formattedDistance, rate: rate, reviewsNumber: reviewsNumber)
                            } else {
                                print("无法将数据转换为图片")
                            }
                        }
                    } else {
                        print("无法从 URL 加载图片数据")
                    }
                }
            } else {
                print("无效的图片 URL")
            }
        }
        
        return cell
    }



}

