//
//  SettingsViewController.swift
//  MapNews
//
//  Created by Hol Yin Ho on 9/8/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//
import UIKit

class SettingsViewController: UITableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = "Section \(indexPath.section) Row \(indexPath.row)"

        return cell
    }

    lazy var headerView: UILabel = {
        let width = UIScreen.main.bounds.width
        let height: CGFloat = 50
        let origin = CGPoint(x: 5, y: 5)
        let headerView = UILabel(frame: CGRect(origin: origin, size: CGSize(width: width, height: height)))
        headerView.text = "Settings"
        headerView.font = UIFont.boldSystemFont(ofSize: 20)
        return headerView
    }()

    override func viewDidLoad() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.tableHeaderView = headerView
    }

}
