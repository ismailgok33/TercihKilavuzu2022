//
//  CityListController.swift
//  TercihKilavuzu2022
//
//  Created by İsmail on 20.09.2021.
//

import UIKit

private let reuseIdentifier =  "cityCell"

protocol CityListDelegate: AnyObject {
    func saveSelectedCities(_ cityListController: CityListController)
}

class CityListController: UITableViewController {
    
    // MARK: - Properties
    
    private var cities = [City]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var selectedCities = [City]()
    
    weak var delegate: CityListDelegate?
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Kaydet", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleSaveButtonTapped), for: .touchUpInside)
        return button
    }()
        
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Vazgeç", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleCancelButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        configureUI()
        fetchCities()
//        loadSelectedCities()
    }
    
    
    // MARK: - Selectors
    
    @objc func handleSaveButtonTapped() {
        delegate?.saveSelectedCities(self)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleCancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        tableView.backgroundColor = .white
        tableView.register(CityCell.self, forCellReuseIdentifier: reuseIdentifier)

    }
    
    func loadSelectedCities() {
        let selectedCityNames = selectedCities.map({ $0.name })
        
        for i in cities.indices {
            if selectedCityNames.contains(cities[i].name) {
                cities[i].isSelected = true
            }
        }
    }
        
    // MARK: - API
    
    func fetchCities() {
//        FirestoreService.shared.fetchCities { cities in
//            self.cities = cities
//            self.loadSelectedCities()
//        }
        
        FirestoreService.shared.fetchStaticCities { cities in
            self.cities = cities
            self.loadSelectedCities()
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
                if !selectedCities.contains(where: { city in
                    city.id == cities[indexPath.row].id
                }) {
                    selectedCities.append(cities[indexPath.row])
                }
            }
            else {
                cell.accessoryType = .none
                selectedCities = selectedCities.filter({ $0.id != cities[indexPath.row].id })
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        view.backgroundColor = .systemGroupedBackground
        
//        let saveButton = UIButton(type: .system)
//        saveButton.setTitle("Kaydet", for: .normal)
//        saveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
//        saveButton.addTarget(self, action: #selector(handleSaveButtonTapped), for: .touchUpInside)
//
//        let cancelButton = UIButton(type: .system)
//        cancelButton.setTitle("Kaydet", for: .normal)
//        cancelButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
//        cancelButton.addTarget(self, action: #selector(handleSaveButtonTapped), for: .touchUpInside)
//
        view.addSubview(saveButton)
        saveButton.centerY(inView: view)
        saveButton.anchor(right: view.rightAnchor, paddingRight: 12)
        
        view.addSubview(cancelButton)
        cancelButton.centerY(inView: view)
        cancelButton.anchor(left: view.leftAnchor, paddingLeft: 12)
        
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
