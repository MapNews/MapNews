//
//  SettingsViewController.swift
//  MapNews
//
//  Created by Hol Yin Ho on 9/8/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//
import UIKit

class SettingsViewController: UIViewController {
    var settings = ["Set Default Location"]

    lazy var headerView: UILabel = {
        let width = UIScreen.main.bounds.width
        let height: CGFloat = 50
        let origin = CGPoint(x: 5, y: 5)
        let headerView = UILabel(frame: CGRect(origin: origin, size: CGSize(width: width, height: height)))
        headerView.text = "Settings"
        headerView.font = UIFont.boldSystemFont(ofSize: 20)
        return headerView
    }()
    lazy var tableView: UITableView = {
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        let size = CGSize(width: width, height: height)
        let origin = CGPoint(x: 0, y: 50)
        let tableView = UITableView(frame: CGRect(origin: origin, size: size))
        tableView.isUserInteractionEnabled = true
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SetCell")
        return tableView
    }()

    override func viewDidLoad() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SetCell", for: indexPath)
        cell.textLabel!.text = settings[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
}
