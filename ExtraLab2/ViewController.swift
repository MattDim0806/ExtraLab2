//
//  ViewController.swift
//  ExtraLab2
//
//  Created by 楊皓麟 on 2023/5/3.
//

import UIKit
import MapKit
import Toast
import CoreLocation
import SwiftyJSON
import Foundation


class StationData : Codable{
    var StationName: stationName
    var StationAddress: String
    var StationPosition: stationPosition
    var StationID: String
}
class stationName : Codable{
    var Zh_tw : String
    var En : String
}
class stationPosition : Codable{
    var PositionLon : Double
    var PositionLat : Double
}


class TimeTableData:Codable{
    var DailyTrainInfo: dailyTrainInfo
    var OriginStopTime: originStopTime
    var DestinationStopTime: destinationStopTime
}
class dailyTrainInfo: Codable{
    var TrainNo: String
    var Direction: Int
    var StartingStationID: String
    var StartingStationName: stationName
    var EndingStationID: String
    var EndingStationName: stationName
}
class originStopTime: Codable{
    var ArrivalTime: String
    var DepartureTime: String
    var StationName: stationName
}
class destinationStopTime: Codable{
    var ArrivalTime: String
    var DepartureTime: String
    var StationName: stationName
}


class restaurantData: Codable{
    var results : results
}
class results: Codable{
    var content : [content]
}
class content: Codable{
    var type : Int
    var lat : Double
    var lng : Double
    var name : String
    var rating : Double
    var vicinity : String
    var photo : String
    var reviewsNumber : Int
}




class jsonModel: Encodable{
    var lastIndex : Int = -1
    var count : Int = 15
    var type : [Int] = [7]
    var lat : Double = 0.0
    var lng : Double = 0.0
    var range : String = "2000"
}

class token : Codable{
    var access_token : String
}

var myRestaurantData: restaurantData!
var myStationData : [StationData]!
var myTimeTableData : [TimeTableData]!
var myTrainData : [TrainInfo]!
var myAccessToken : token!
class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var switchBtn: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var currentLocationBtn: UIButton!
    @IBOutlet weak var endTextField: UITextField!
    @IBOutlet weak var startTextField: UITextField!
    
    @IBOutlet weak var timeBtn: UIButton!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label1: UILabel!
    var location:CLLocationManager? = nil
    var accessToken : String!
    var accessToken1 : String! //"eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJER2lKNFE5bFg4WldFajlNNEE2amFVNm9JOGJVQ3RYWGV6OFdZVzh3ZkhrIn0.eyJleHAiOjE2ODQ3NTg1MDAsImlhdCI6MTY4NDY3MjEwMCwianRpIjoiYzA4ZTA2M2UtM2U4NC00YzVlLWE0MTMtNjcyNjQ2YTNjODcyIiwiaXNzIjoiaHR0cHM6Ly90ZHgudHJhbnNwb3J0ZGF0YS50dy9hdXRoL3JlYWxtcy9URFhDb25uZWN0Iiwic3ViIjoiMDkxYWFmODAtMGQ4ZC00N2RiLTg0ZDctMTQ4ZTAzMGViMTYwIiwidHlwIjoiQmVhcmVyIiwiYXpwIjoidDEwODM2MDEyNS1lYTE4NGEzMC1hZjFjLTQwZTQiLCJhY3IiOiIxIiwicmVhbG1fYWNjZXNzIjp7InJvbGVzIjpbInN0YXRpc3RpYyIsInByZW1pdW0iLCJtYWFzIiwiYWR2YW5jZWQiLCJ2YWxpZGF0b3IiLCJoaXN0b3JpY2FsIiwiYmFzaWMiXX0sInNjb3BlIjoicHJvZmlsZSBlbWFpbCIsInVzZXIiOiI5ZTQxZTFkYyJ9.fkv1ncOEsqMT3Ou7DIRlDdSgWrFFeJlnRNg9PjkZVsHoV51QwIlElUKkfw6sv_5hgtRSp1coIAYpAP-sTtx3-1l32DVE-fBIL0e27JWPmp4F7N-q-UDZGWYwCwZUpMpWQjkWa9P-3NhRPrbxB1u55D4oeXPmOOPnPE7DVkk10GRDc0Jt0jow9dWm7CrrnxjH4ZXZS7MCYt1b6_MyVBdLqZolmuWeRpk-pu-F0uHBM-FKHBuT5XMleqW_D9XWmJ4EKJJ-8Dq_XFyMMNzsmFk8mV9SQxmjO9RGVULzZCKdLjRLPP0e-xTEdPgp6-pJcCWoxwErXSNWQiLckQLi4Mb79A"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startTextField.delegate = self
        endTextField.delegate = self
       //grantToken
        let url = URL(string: "https://tdx.transportdata.tw/auth/realms/TDXConnect/protocol/openid-connect/token")!
        var request = URLRequest(url: url)
        request.httpMethod = "post"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
        let clientId = "t108360125-ea184a30-af1c-40e4"
        let clientSecret = "54fa8f4b-4da0-4228-aff2-756872714599"
        let data = "grant_type=client_credentials&client_id=\(clientId)&client_secret=\(clientSecret)".data(using: .utf8)
        request.httpBody = data
        let task = URLSession.shared.dataTask(with: request){ data, response, error in
            if(error != nil){
                print("發送失敗", error!.localizedDescription)
            }
            else{
                print("得到access token!!")
                self.accessToken = String(data: data!, encoding: .utf8)
                print(self.accessToken!)
                if let accessTokenData = self.accessToken.data(using: .utf8) {
                    do {
                        let data = try JSONDecoder().decode(token.self, from: accessTokenData)
                        self.accessToken1 = data.access_token
                        print(data.access_token)
                    } catch {
                        print("獲取access Token失敗！！")
                    }
                } else {
                    print("無效的Access Token")
                }
                self.getStationApi()
            }
        }
        task.resume()
        btnSizeChange()
        requestGPS()
    }


    @IBAction func switchTextFieldBtnClk(_ sender: Any) {
        let temp : String
        //讓startTextField與endTextField的文字交換
        temp = startTextField.text!
        startTextField.text = endTextField.text!
        endTextField.text = temp
    }
    
    func requestGPS(){
        location = CLLocationManager()
        location?.requestWhenInUseAuthorization()
        location?.startUpdatingLocation()
        mapView.showsUserLocation = true
    }
    
    func getStationApi(){
        let url = URL(string: "https://tdx.transportdata.tw/api/basic/v2/Rail/THSR/Station?%24top=30&%24format=JSON")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken1!)", forHTTPHeaderField: "authorization")
        //request.setValue("Bearer eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJER2lKNFE5bFg4WldFajlNNEE2amFVNm9JOGJVQ3RYWGV6OFdZVzh3ZkhrIn0.eyJleHAiOjE2ODQzMjUzMjMsImlhdCI6MTY4NDIzODkyMywianRpIjoiOGQzOGFlMDMtODA1MC00MWZkLWIwYjUtOGUyNjE4ZTdjODk1IiwiaXNzIjoiaHR0cHM6Ly90ZHgudHJhbnNwb3J0ZGF0YS50dy9hdXRoL3JlYWxtcy9URFhDb25uZWN0Iiwic3ViIjoiMDkxYWFmODAtMGQ4ZC00N2RiLTg0ZDctMTQ4ZTAzMGViMTYwIiwidHlwIjoiQmVhcmVyIiwiYXpwIjoidDEwODM2MDEyNS1lYTE4NGEzMC1hZjFjLTQwZTQiLCJhY3IiOiIxIiwicmVhbG1fYWNjZXNzIjp7InJvbGVzIjpbInN0YXRpc3RpYyIsInByZW1pdW0iLCJtYWFzIiwiYWR2YW5jZWQiLCJ2YWxpZGF0b3IiLCJoaXN0b3JpY2FsIiwiYmFzaWMiXX0sInNjb3BlIjoicHJvZmlsZSBlbWFpbCIsInVzZXIiOiI5ZTQxZTFkYyJ9.dMYJSdy5bn7ZWyjxYNsY1I56ZVSZnv_NMTuA69eeHcOLPOzAdIWYh0dDIHtAQqbidp109LlX4nYYsX4SDSd031qdoLpRU5Sc705GwdyFAfk3VI43AB7_PW31jPORE61dSNS--a5Rpl09q1KT4OBTcBoYzT1kNx5Rh_TdTpNkdFdYOUPrMza_xffiriwl17uMvv3V6ICCahOaYdtNf7X6d6vTBsqSsuefa7eyaHJI0Yj7YM2HGq7L2tNQciEy_G1HYsFJAvOCfpbPdHhI2E3EzSnBA_fi3uxBHXBRoMGXPk5cCEVbZ-5K1_KYj4veMJdDcBoV1V2oJvn8Lw0RUrEIrQ", forHTTPHeaderField: "authorization")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request){ data, response, error in
            if(error != nil){
                print("發送失敗", error!.localizedDescription)
            }
            else{
                myStationData = try! JSONDecoder().decode([StationData].self, from: data!)
                print(myStationData.count)
                self.addAnnotation()
                //重新整理mapView
            }
        }
        task.resume()
    }
    
    func getTimeTableApi(startID: String, endID: String){
        print("起點車站ID：" + startID)
        print("終點車站ID" + endID)
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: currentDate)
        print("今日日期：" + dateString) // 输出：2023-05-20
        //let url = URL(string: "https://tdx.transportdata.tw/api/basic/v2/Rail/THSR/DailyTimetable/OD/" + startID + "/to/" + endID + "/2023-05-20?%24top=30&%24format=JSON")!
        let url = URL(string: "https://tdx.transportdata.tw/api/basic/v2/Rail/THSR/DailyTimetable/OD/" + startID + "/to/" + endID + "/" + dateString + "?%24top=30&%24format=JSON")!
        print(url)
        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken1!)", forHTTPHeaderField: "authorization")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request){ data, response, error in
            if(error != nil){
                print("發送失敗", error!.localizedDescription)
            }
            else{
                DispatchQueue.main.async {
                    myTimeTableData = try! JSONDecoder().decode([TimeTableData].self, from: data!)
                    let VC = timeTableViewController()
                    VC.accessToken1 = self.accessToken1
                    self.present(VC, animated: true)
                }
            }
        }
        task.resume()
    }
    
    //放置標註
    func addAnnotation(){
        for number in 0..<myStationData.count {
            let annotation = MKPointAnnotation()
            let lat = myStationData[number].StationPosition.PositionLat
            let lng = myStationData[number].StationPosition.PositionLon
            let name = myStationData[number].StationName.Zh_tw
            let latLng = CLLocationCoordinate2DMake(lat, lng)
            annotation.coordinate = latLng
            annotation.title = name + "高鐵站"
            mapView.addAnnotation(annotation)
            //mapView.reloadInputViews()
        }
        
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    func setToSelectCell(lat: Double, lng:Double){
        let Coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: Coordinate, span: span)
        //print(String(format: "lat: %.2f, lng: %.2f", lat, lng))
        mapView.setRegion(region, animated: true)
    }
    
    func btnSizeChange(){
        //改變switchBtn的大小
        let scale: CGFloat = 1 // 缩放因子
        currentLocationBtn.transform = CGAffineTransform(scaleX: scale, y: scale)
        searchBtn.layer.cornerRadius = 10
        timeBtn.layer.cornerRadius = 10
        label1.layer.cornerRadius =  10
        label1.layer.masksToBounds = true
        label2.layer.cornerRadius =  10
        label2.layer.masksToBounds = true
    }
    
    @IBAction func currentLocationBtnClick(_ sender: Any) {
            mapView.setCenter(mapView.userLocation.coordinate, animated: true)
    }
    @IBAction func timeTableBtnClick(_ sender: Any) {
        var flag = 0
        let substring = "高鐵站"
        let startResult : String = startTextField.text?.replacingOccurrences(of: substring, with: "") ?? ""
        let endResult : String = endTextField.text?.replacingOccurrences(of: substring, with: "") ?? ""
        for startIndex in 0..<myStationData.count {
            if myStationData[startIndex].StationName.Zh_tw.contains(startResult){
                for endIndex in 0..<myStationData.count{
                    if myStationData[endIndex].StationName.Zh_tw.contains(endResult){
                        if startIndex == endIndex{
                            view.makeToast("起點與終點不可相同！")
                            return
                        }
                        flag = 1
                        getTimeTableApi(startID: myStationData[startIndex].StationID, endID: myStationData[endIndex].StationID)
                        //present(VC, animated: true)
                    }
                }
            }
        }
        if flag == 0{
            view.makeToast("請檢查站點名稱是否正確！")
        }
    }
    @IBAction func searchBtnClick(_ sender: Any) {
        let VC = searchPopUpViewController()
        VC.delegate = self
        VC.textFlag = -1
        VC.showInVC(VC: self)
    }
}


extension ViewController: searchPopUpViewControllerDelegate {
    func setNewPlace(lat: Double, lng: Double) {
        setToSelectCell(lat: lat, lng: lng)
    }
    func setNewText0(stationText: String) {
        startTextField.text = stationText
    }
    func setNewText1(stationText: String) {
        endTextField.text = stationText
    }
    
}

extension ViewController : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField){
        let VC = searchPopUpViewController()
        if textField == startTextField {
            VC.textFlag = 0
        } else if textField == endTextField {
            VC.textFlag = 1
        }
        VC.delegate = self
        VC.showInVC(VC: self)
    }
        
}

extension ViewController:MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation {
            let stationName = annotation.title
            let actionSheetController = UIAlertController(title: stationName!, message: "", preferredStyle: .actionSheet)
            let setStartStation = UIAlertAction(title: "設定為起點", style: .default, handler: {
                (action: UIAlertAction!) -> Void in
                self.startTextField.text = stationName!
            })
            let setEndStation = UIAlertAction(title: "設定為終點", style: .default, handler: {
                (action: UIAlertAction!) -> Void in
                self.endTextField.text = stationName!
            })
            
            let findRestaurnt = UIAlertAction(title: "附近餐廳", style: .default, handler: {
                (action: UIAlertAction!) -> Void in
                let apiUrl = "https://api.bluenet-ride.com/v2_0/lineBot/restaurant/GET"
                let url = URL(string: apiUrl)!
                var request = URLRequest(url: url)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpMethod = "POST"
                let json = jsonModel()
                
                json.lat = annotation.coordinate.latitude
                json.lng = annotation.coordinate.longitude
                let jsonData = try! JSONEncoder().encode(json)
                request.httpBody = jsonData
                let task = URLSession.shared.dataTask(with: request){ data, response, error in
                    if(error != nil){
                        print("發送失敗", error!.localizedDescription)
                    }
                    else{
                        DispatchQueue.main.async {
                            do{
                                myRestaurantData = try JSONDecoder().decode(restaurantData.self, from: data!)
                            }catch{
                                print("錯誤:\(error)")
                            }
                            let VC = restaurantTableViewController()
                            VC.lat = annotation.coordinate.latitude
                            VC.lng = annotation.coordinate.longitude
                            self.present(VC, animated: true)
                        }
                    }
                }
                task.resume()
            })
            let cancel = UIAlertAction(title: "取消", style: .cancel)
            actionSheetController.addAction(setStartStation)
            actionSheetController.addAction(setEndStation)
            actionSheetController.addAction(findRestaurnt)
            actionSheetController.addAction(cancel)
            present(actionSheetController, animated: true, completion: nil)
        }
    }
}

