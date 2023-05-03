//
//  searchPopUpViewController.swift
//  ExtraLab2
//
//  Created by 楊皓麟 on 2023/5/7.
//
import UIKit
import MapKit

class searchPopUpViewController: UIViewController {
    @IBOutlet weak var normalView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var TGR: UITapGestureRecognizer!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    
    var textFlag : Int = -1
    var startText : String = ""
    var endText : String = ""
    var cellCount : Int = myStationData.count
    var matchedIndexes : [Int] = []
    weak var delegate:searchPopUpViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewInit()
        //設定normalView為圓角
        normalView.layer.cornerRadius = 10
        //tap gesture在此view上時，不會觸發tapGesture function
        TGR.cancelsTouchesInView = false
        print(textFlag)
    }

    func showInVC(VC:UIViewController){
        self.modalPresentationStyle = .overCurrentContext
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = .fade
        VC.view.window?.layer.add(transition, forKey: kCATransition)
        VC.present(self, animated: false){
            self.tableView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            self.tableView.alpha = 0
            UITableView.animate(withDuration: 0){
                self.tableView.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.tableView.alpha = 1
            }
        }
    }
    
    @IBAction func searchBtnClick(_ sender: Any) {
        searchTextField.resignFirstResponder()
        let searchBarLowercased = searchTextField.text?.lowercased() ?? ""
        matchedIndexes = []
        for index in 0..<myStationData.count {
            if myStationData[index].StationName.Zh_tw.lowercased().contains(searchBarLowercased) || myStationData[index].StationAddress.lowercased().contains(searchBarLowercased) {
                matchedIndexes.append(index)
            }
        }
        //判斷searchTextField是否為空
        
        if searchTextField.text?.isEmpty == true{
            cellCount = myStationData.count
        }
        else{
            cellCount = matchedIndexes.count
        }
        tableView.reloadData()
    }
    
    //設定當點擊到normalView以外的地方時，關閉此view
    @IBAction func tapGesture(_ sender: Any) {
        let touchLocation = (sender as AnyObject).location(in: normalView)
            if normalView.bounds.contains(touchLocation) {
                return // 如果触摸位置在normalView内部，则不执行后续代码
            }
            print("觸發TGR")
            dismissViewController()
    }
    
    
    func dismissViewController(){
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = .fade
        view.window?.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false, completion: nil)
    }
    
    func tableViewInit(){
        let cellNIB = UINib(nibName: "searchTableViewCell", bundle: nil)
        tableView.register(cellNIB, forCellReuseIdentifier: "cell")
    }
    
}

extension searchPopUpViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section : Int) -> Int {
        return cellCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! searchTableViewCell
        // 取得符合搜尋結果的內容的index
        if(matchedIndexes == []){ // 如果沒有符合的搜尋結果，就顯示所有資料
            cell.nameLabel.text = myStationData[indexPath.row].StationName.Zh_tw
            cell.vicinityLabel.text = myStationData[indexPath.row].StationAddress
            return cell
        }
        else{
            // 用符合搜尋結果的index去取得資料
            let matchedIndex = matchedIndexes[indexPath.row]
            cell.nameLabel.text = myStationData[matchedIndex].StationName.Zh_tw
            cell.vicinityLabel.text = myStationData[matchedIndex].StationAddress
            return cell
        }
    }
}


extension searchPopUpViewController:UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TGR.isEnabled = false
        var lat : Double = 0.0
        var lng : Double = 0.0
        var newStation : String = ""
        if(matchedIndexes == []){ // 如果沒有符合的搜尋結果，就顯示所有資料
            lat = myStationData[indexPath.row].StationPosition.PositionLat
            lng = myStationData[indexPath.row].StationPosition.PositionLon
            newStation = myStationData[indexPath.row].StationName.Zh_tw + "高鐵站"
        }
        else{
            // 用符合搜尋結果的index去取得資料
            let matchedIndex = matchedIndexes[indexPath.row]
            lat = myStationData[matchedIndex].StationPosition.PositionLat
            lng = myStationData[matchedIndex].StationPosition.PositionLon
            newStation = myStationData[matchedIndex].StationName.Zh_tw + "高鐵站"
        }
        dismissViewController()
        if(textFlag == -1){
            delegate?.setNewPlace(lat: lat, lng: lng)
        }
        else if(textFlag == 0){
            delegate?.setNewText0?(stationText: newStation)
        }
        else if(textFlag == 1){
            delegate?.setNewText1?(stationText: newStation)
        }
    }
}

@objc protocol searchPopUpViewControllerDelegate {
    @objc func setNewPlace(lat: Double, lng: Double)
    @objc optional func setNewText0(stationText: String)
    @objc optional func setNewText1(stationText: String)
}
