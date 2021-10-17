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
    
    let searchController = UISearchController()

    
    private var cities = [City]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private var searchedCities: [City]? {
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
    
    override func viewDidAppear(_ animated: Bool) {
       super.viewDidAppear(animated)
       searchController.searchBar.becomeFirstResponder()
    }
    
    
    // MARK: - Selectors
    
    @objc func handleSaveButtonTapped() {
        delegate?.saveSelectedCities(self)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleCancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        tableView.backgroundColor = .white
        tableView.register(CityCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.keyboardDismissMode = .onDrag

        searchController.searchBar.searchBarStyle = .default
        searchController.searchBar.searchTextField.backgroundColor = UIColor.white
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Arayınız..."
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
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
        
        FirestoreService.shared.fetchStaticCities { cities in
            self.cities = cities
            self.loadSelectedCities()
        }
    }
}

// MARK: - TableViewDatasource

extension CityListController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let searchedCities = searchedCities {
            return searchedCities.count
        }
        return cities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! CityCell
        
        if let searchedCities = searchedCities {
            cell.city = searchedCities[indexPath.row]
            if let city = cell.city {
                if city.isSelected {
                    cell.accessoryType = .checkmark
                    
                    if !selectedCities.contains(where: { city in
                        city.id == searchedCities[indexPath.row].id
                    }) {
                        selectedCities.append(searchedCities[indexPath.row])
                    }
                }
                else {
                    cell.accessoryType = .none
                    selectedCities = selectedCities.filter({ $0.id != searchedCities[indexPath.row].id })
                }
            }
        }
        else {
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
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        view.backgroundColor = .white
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
        
        self.searchController.searchBar.resignFirstResponder()
        self.searchController.searchBar.endEditing(true)
        
        if var searchCityList = searchedCities {
            let city = searchedCities?[indexPath.row]
            searchedCities?[indexPath.row].isSelected = !(city?.isSelected ?? false)
            
            // Toggle isSelected of the main departments array when searched departments array'e element is toggled
            for (index, value) in cities.enumerated() {
                if value.name == city?.name {
                    cities[index].isSelected = !(city?.isSelected ?? false)
                }
            }
        }
        else {
            let city = cities[indexPath.row]
            cities[indexPath.row].isSelected = !city.isSelected
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

// MARK: - UISearchResultsUpdating

extension CityListController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, !text.isEmpty {
            searchedCities = cities.filter({ city in
                city.name.localizedCaseInsensitiveContains(text)
            })
        }
        else {
            searchedCities = nil
        }
    }
    
}
