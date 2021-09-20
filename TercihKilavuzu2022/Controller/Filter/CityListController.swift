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
    
    private var cities = [City]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        configureUI()
        fetchCities()
    }
    
    
    // MARK: - Selectors
    
    @objc func handleSaveButtonTapped() {
        print("DEBUG: save button tapped in City Controller..")
    }
    
    
    // MARK: - Helpers
    
    func configureUI() {
        tableView.backgroundColor = .white
        tableView.register(CityCell.self, forCellReuseIdentifier: reuseIdentifier)

    }
    
    // MARK: - API
    
    func fetchCities() {
        FirestoreService.shared.fetchCities { cities in
            self.cities = cities
        }
    }
}

// MARK: - TableViewDatasource

extension CityListController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! CityCell
        cell.city = cities[indexPath.row]
        
        if var city = cell.city {
            city.isSelected = cities[indexPath.row].isSelected
            if city.isSelected {
                cell.accessoryType = .checkmark
            }
            else {
                cell.accessoryType = .none
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        view.backgroundColor = .systemGroupedBackground
        
        let button = UIButton(type: .system)
        button.setTitle("Kaydet", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleSaveButtonTapped), for: .touchUpInside)
        
        view.addSubview(button)
        button.centerY(inView: view)
        button.anchor(right: view.rightAnchor, paddingRight: 12)
        
        return view
    }
}

// MARK: - TableViewDelegate

extension CityListController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let city = cities[indexPath.row]
        cities[indexPath.row].isSelected = !city.isSelected
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
