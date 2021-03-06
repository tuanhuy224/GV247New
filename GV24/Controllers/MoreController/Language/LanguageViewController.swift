//
//  LanguageViewController.swift
//  GV24
//
//  Created by HuyNguyen on 5/31/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

class LanguageViewController: BaseViewController {
   
    @IBOutlet weak var tbLanguage: UITableView!

    var languages: [Locale] = [Locale(languageCode: "vi", countryCode: "vi", name: "VietNam"),
                               Locale(languageCode: "en", countryCode: "en", name: "English")]
    var selectedLanguage = DGLocalization.sharedInstance.getCurrentLanguage()
    var rowsWhichAreChecked = [NSIndexPath]()
    var isSelection:Int = 0

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tbLanguage.register(UITableViewCell.self, forCellReuseIdentifier: DefaultCellID)
    }

    
    override func setupViewBase() {
        self.title = "Language".localize
        BackButtonItem()
    }
    
    override func viewDidLayoutSubviews() {
        tbLanguage.separatorInset = .zero
        tbLanguage.layoutMargins = .zero
    }
}


extension LanguageViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tbLanguage.dequeueReusableCell(withIdentifier: DefaultCellID, for: indexPath)
        let language = languages[indexPath.row]
        if let name = language.name as String? {
            cell.textLabel?.text = name.localize
        }
        cell.textLabel?.font = fontSize.fontName(name: .light, size: sizeFive)
        cell.selectionStyle = .none
        
        // show checkmark for selected language
        if language.IOSLanguageCode() == selectedLanguage.IOSLanguageCode(){
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }


        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}


extension LanguageViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let language = languages[indexPath.row]
        DGLocalization.sharedInstance.setLanguage(withCode: language)
        selectedLanguage = language
        self.title = "Language".localize
        self.decorate()
        
        tableView.reloadData()
            if indexPath.row == 0 {
                let VietNam = Locale().initWithLanguageCode(languageCode: "vi", countryCode: "vi", name: "Viet Nam")
                DGLocalization.sharedInstance.setLanguage(withCode:VietNam)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationIdentifier), object: nil)
                //Load selected Language to Views
                self.title = "Language".localize
                self.isSelection = 0
                self.decorate()
            }else {
                let english = Locale().initWithLanguageCode(languageCode: "en", countryCode: "en", name: "United Kingdom")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationIdentifier), object: nil)
                DGLocalization.sharedInstance.setLanguage(withCode:english)
                //Load selected Language to Views
                self.title = "Language".localize
                self.isSelection = 1
                self.decorate()
            }

    }

}





