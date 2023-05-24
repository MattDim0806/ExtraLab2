//
//  searchPopUpViewController.swift
//  ExtraLab2
//
//  Created by 楊皓麟 on 2023/5/7.
//
import UIKit
import MapKit

class searchPopUpViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var normalView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var TGR: UITapGestureRecognizer!
    @IBOutlet weak var searchTextField: UITextField!
    
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
        searchTextField.delegate = self
        searchTextField.becomeFirstResponder()
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
 
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            let searchBarLowercased = text.lowercased()
            matchedIndexes = []
            if searchBarLowercased.isEmpty {
                cellCount = myStationData.count
            } else {
                for index in 0..<myStationData.count {
                    if myStationData[index].StationName.Zh_tw.lowercased().contains(searchBarLowercased) || myStationData[index].StationAddress.lowercased().contains(searchBarLowercased) {
                        matchedIndexes.append(index)
                    }
                }
                cellCount = matchedIndexes.count
            }
            tableView.reloadData()
        }
    }


    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          textField.resignFirstResponder()
          return true
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

extension searchPopUpViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! searchTableViewCell

        if matchedIndexes.isEmpty {
            let station = myStationData[indexPath.row]
            cell.nameLabel.text = station.StationName.Zh_tw
            cell.vicinityLabel.text = station.StationAddress
        } else {
            let matchedIndex = matchedIndexes[indexPath.row]
            let station = myStationData[matchedIndex]
            cell.nameLabel.text = station.StationName.Zh_tw
            cell.vicinityLabel.text = station.StationAddress
        }

        return cell
    }
}

extension searchPopUpViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var lat: Double = 0.0
        var lng: Double = 0.0
        var newStation: String = ""

        if matchedIndexes.isEmpty {
            let station = myStationData[indexPath.row]
            lat = station.StationPosition.PositionLat
            lng = station.StationPosition.PositionLon
            newStation = station.StationName.Zh_tw + "高鐵站"
        } else {
            let matchedIndex = matchedIndexes[indexPath.row]
            let station = myStationData[matchedIndex]
            lat = station.StationPosition.PositionLat
            lng = station.StationPosition.PositionLon
            newStation = station.StationName.Zh_tw + "高鐵站"
        }

        dismissViewController()

        switch textFlag {
        case -1:
            delegate?.setNewPlace(lat: lat, lng: lng)
        case 0:
            delegate?.setNewText0?(stationText: newStation)
        case 1:
            delegate?.setNewText1?(stationText: newStation)
        default:
            break
        }
    }
}


@objc protocol searchPopUpViewControllerDelegate {
    @objc func setNewPlace(lat: Double, lng: Double)
    @objc optional func setNewText0(stationText: String)
    @objc optional func setNewText1(stationText: String)
}
