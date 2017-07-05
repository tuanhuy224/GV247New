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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tbLanguage.register(UITableViewCell.self, forCellReuseIdentifier: DefaultCellID)
    }
    
    override func setupViewBase() {
        self.title = "Language".localize
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tbLanguage.dequeueReusableCell(withIdentifier: DefaultCellID, for: indexPath)
        let language = languages[indexPath.row]
        
        // cell configure
        if let name = language.name as String? {
            cell.textLabel?.text = name.localize
        }
        cell.textLabel?.font = UIFont(name: "SFUIText-Light", size: 13)
        cell.selectionStyle = .none
        
        // show checkmark for selected language
        if language.IOSLanguageCode() == selectedLanguage.IOSLanguageCode() {
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
    }

}





