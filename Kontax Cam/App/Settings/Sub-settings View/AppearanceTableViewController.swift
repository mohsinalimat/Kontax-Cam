//
//  AppearanceTableViewController.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 6/6/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import PanModal

class AppearanceTableViewController: UITableViewController {
    
    private let themes: [UIUserInterfaceStyle] = [.unspecified, .light, .dark]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureNavigationBar(tintColor: .label, title: "Appearance", preferredLargeTitle: false, removeSeparator: true)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "appearanceCell")
        
        self.tableView.separatorStyle = .none
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return themes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "appearanceCell", for: indexPath)

        switch themes[indexPath.row].rawValue {
        case 0: cell.textLabel?.text = "System"
        case 1: cell.textLabel?.text = "Light"
        case 2: cell.textLabel?.text = "Dark"
        default: break
        }
        
        let appearanceValue = UIUserInterfaceStyle(rawValue: UserDefaultsHelper.shared.getData(type: Int.self, forKey: .userAppearance) ?? 0)
        if appearanceValue! == themes[indexPath.row] {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        // Save to user defaults
        UserDefaultsHelper.shared.setData(value: themes[indexPath.row].rawValue, key: .userAppearance)
        
        UIApplication.shared.windows.forEach { window in
            window.overrideUserInterfaceStyle = themes[indexPath.row]
        }
        
        navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }

}

extension AppearanceTableViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return tableView
    }
}
