//
//  LanguageViewController.swift
//  GV24
//
//  Created by HuyNguyen on 5/31/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

class LanguageViewController: BaseViewController {
    var languages:[String] = ["VietNam","English"]
    @IBOutlet weak var tbLanguage: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tbLanguage.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
    }
    override func setupViewBase() {
        self.title = "Language".localize
    }
}
extension LanguageViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = (tbLanguage.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath))
        let lang = DGLocalization.sharedInstance.getCurrentLanguage()
        if lang.languageCode == "en" {
            cell.textLabel?.text  = languages[indexPath.row].localize
        }
        cell.textLabel?.text  = languages[indexPath.row].localize
        cell.textLabel?.font = UIFont(name: "SFUIText-Light", size: 13)
        return cell
    }
}
extension LanguageViewController:UITableViewDelegate{

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if indexPath.row == 0 {
                let Nepali = Locale().initWithLanguageCode(languageCode: "vi", countryCode: "vi", name: "Viet Nam")
                DGLocalization.sharedInstance.setLanguage(withCode:Nepali)
                //Load selected Language to Views
                self.title = "Language".localize
                self.decorate()
            }
            else {
                let english = Locale().initWithLanguageCode(languageCode: "en", countryCode: "gb", name: "United Kingdom")
                DGLocalization.sharedInstance.setLanguage(withCode:english)
                //Load selected Language to Views
                self.title = "Language".localize
                self.decorate()
            }
    }
}
