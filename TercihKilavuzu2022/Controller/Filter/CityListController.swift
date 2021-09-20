//
//  CityListController.swift
//  TercihKilavuzu2022
//
//  Created by İsmail on 20.09.2021.
//

import UIKit

private let reuseIdentifier =  "cityCell"

class CityListController: UITableViewController {
    
    // MARK: - Properties
    
    private var cities = [City(id: 1, name: "Ankara", isSelected: false),
    City(id: 2, name: "İstanbul", isSelected: false),
    City(id: 3, name: "Mersin", isSelected: false)] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        configureUI()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .blue

    }
}

// MARK: - TableViewDatasource

extension CityListController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.textLabel?.text = cities[indexPath.row].name
        cell.isSelected = cities[indexPath.row].isSelected
        if cell.isSelected {
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryType = .none
        }
        return cell
    }
}

// MARK: - TableViewDelegate

extension CityListController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        var city = cities[indexPath.row]
        cities[indexPath.row].isSelected = !city.isSelected
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
