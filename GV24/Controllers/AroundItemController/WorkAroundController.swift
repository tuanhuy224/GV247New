//
//  WorkAround.swift
//  GV24
//
//  Created by admin on 5/24/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import IoniconsSwift
import Alamofire
import SwiftyJSON
import Kingfisher

class WorkAroundController: BaseViewController {
    @IBOutlet weak var arWork: WorkAround!
    var cellHeight: CGFloat?
    var  user:User?
    var id:String?
    var logtitude:Double?
    var lattitude:Double?
    var arrays = [Around]()
    
    var work = [WorkName]()
    @IBOutlet weak var aroundTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        aroundTableView.register(UINib(nibName:"WorkTableViewCell",bundle: nil), forCellReuseIdentifier: "workCell")
        aroundTableView.addSubview(handleRefresh)
        arWork.setupView()
        setup()
        self.loadData()
    }
    override func setupViewBase() {
        if UserDefaultHelper.getSlider() != "" {
            if UserDefaultHelper.getSlider() == nil {
                return
            }
            arWork.sliderMax.text = "\(UserDefaultHelper.getSlider()!)"
            arWork.slider.setValue(Float(UserDefaultHelper.getSlider()!)!, animated: true)
        }
    }
    lazy var handleRefresh:UIRefreshControl = {
    let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(WorkAroundController.handleRef), for: .valueChanged)
        return refresh
    }()
    
    func handleRef() {
        loadData()
    }
    func setup(){
        
        arWork.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Nearbyjobs".localize
        self.customBarLeftButton()
    }
    func customBarLeftButton(){
        let image = Ionicons.checkmark.image(12).maskWithColor(color: UIColor.colorWithRedValue(redValue: 24, greenValue: 179, blueValue: 110, alpha: 1))
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.addTarget(self, action: #selector(WorkAroundController.selectButton), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        
    }
    func selectButton() {
        navigationController?.pushViewController(DetailViewController(), animated: true)
    }
    func loadData() {
        let url = "https://yukotest123.herokuapp.com/en/more/getTaskAround"
        let apiService = APIService.shared
        let param:[String:Double] = ["lng": 106.6882557,"lat": 10.7677238]
        handleRefresh.endRefreshing()
        apiService.getAllAround(url: url, method: .get, parameters: param, encoding: URLEncoding.default) { (json, string) in
            if let jsonArray = json?.array{
                for data in jsonArray{
                self.arrays.append(Around(json: data))
                }
                self.aroundTableView.reloadData()
            }
        }
    }
}
extension WorkAroundController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return arrays.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell: WorkTableViewCell = (aroundTableView.dequeueReusableCell(withIdentifier: "workCell", for: indexPath) as? WorkTableViewCell)!
        cell.lbWork.text = "\(arrays[indexPath.row].id!.name!)"
        cell.amountWork.text = "\(arrays[indexPath.row].count!)"
        let image = URL(string: arrays[indexPath.row].id!.image!)
        DispatchQueue.main.async {
             cell.imageWork.kf.setImage(with: image)
        }
        cell.delegate = self as? sendIdForViewDetailDelegate
            return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let vc = AroundItemController(nibName: "AroundItemController", bundle: nil)
            vc.id = "\(arrays[indexPath.row].id!.id!)"
            vc.name = "\(arrays[indexPath.row].id!.name!)"
            navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
}
extension WorkAroundController:changeSliderDelegate{
    func change(slider: UISlider) {
        if slider.isContinuous == true {
            arWork.sliderMax.text = String(stringInterpolation: "\(slider.value)")
            UserDefaultHelper.setSlider(slider: "\(slider.value)")
        }
    }
}


