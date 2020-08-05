//
//  PromptDefaultLocationViewController.swift
//  MapNews
//
//  Created by Hol Yin Ho on 5/8/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//
import UIKit

class PromptDefaultLocationViewController: UIViewController {
    var countries: [String] = []
    var selectCountryCallback: (String) -> Void = {_ in }
    lazy var locationTable: UITableView = {
        let tableView = UITableView(frame: self.view.frame)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()
    override func viewDidLoad() {
        view.addSubview(locationTable)

        locationTable.delegate = self
        locationTable.dataSource = self
    }
}

extension PromptDefaultLocationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        countries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel!.text = countries[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCountry = countries[indexPath.row]
        guard let presenter = presentingViewController as? MapViewController else {
            return
        }
        presenter.setDefaultLocation(to: selectedCountry)
        self.dismiss(animated: true, completion: {})
    }

}
