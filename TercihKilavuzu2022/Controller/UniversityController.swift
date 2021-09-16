//
//  UniversityController.swift
//  TercihKilavuzu2022
//
//  Created by İsmail on 11.09.2021.
//

import UIKit
import RealmSwift

private let reuseIdentifier = "universityCell"

protocol UniversityControllerDelegate: AnyObject {
    func handleFavoriteTappedAtUniversityController(_ cell: UniversityCell)
}

class UniversityController: UITableViewController {
    
    // MARK: - Properties
    
    let realm = try! Realm()
    
    let searchController = UISearchController()
    
    weak var delegate: UniversityControllerDelegate?
    
    private var universities = [University]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private var searchedUniversities: [University]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var favorites: Results<University>? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .myCustomBlue
        button.setImage(UIImage(named: "new_tweet"), for: .normal)
        button.addTarget(self, action: #selector(handleFilterButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchUniversities()
        sortUniversitiesByNameAsc()
    }
    
    // MARK: - Helpers
    
    func configureUI() {        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UniversityCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.allowsSelection = false
        
        view.addSubview(actionButton)
        actionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 32, paddingRight: 16)
        actionButton.setDimensions(width: 56, height: 56)
        actionButton.layer.cornerRadius = 56 / 2
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Arayınız..."
        navigationItem.searchController = searchController
    }
    
    func sortUniversitiesByNameAsc() {
        universities = universities.sorted(by: { $0.name < $1.name })
    }
    
    
    
    // MARK: - API
    
    func fetchUniversities() {
        FirestoreService.shared.fetchUniversities { universities in
            self.universities = universities
            self.loadFavorites()
        }
    }
    
    func loadFavorites() {
        favorites = realm.objects(University.self)
                
        guard let favorites = favorites else { return }
        
        for favorite in favorites {
            guard let i = universities.firstIndex(where: {$0.uid == favorite.uid}) else { return }
            universities[i].isFavorite = true
        }
    }
    
    func changeFavoritesFromFavoritesController(withFavorite favorite: University) {
        loadFavorites()

        guard let i = universities.firstIndex(where: {$0.uid == favorite.uid}) else { return }
        universities[i].isFavorite.toggle()
        
    }
        
    
    // MARK: - Selectors
    @objc func handleFilterButtonTapped() {
        print("DEBUG: filter button tapped..")
    }
}

// MARK: - TableView Delegate/Datasource methods

extension UniversityController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let searchedUniversities = searchedUniversities {
            return searchedUniversities.count
        }
        else {
            return universities.count
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UniversityCell
        if let searchedUniversities = searchedUniversities {
            cell.university = searchedUniversities[indexPath.row]
        }
        else {
            cell.university = universities[indexPath.row]
        }
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

// MARK: - UniversityCellDelegate

extension UniversityController: UniversityCellDelegate {
    func handleFavoriteTapped(_ cell: UniversityCell) {
        
        delegate?.handleFavoriteTappedAtUniversityController(cell)
    }
}


extension UniversityController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, !text.isEmpty {
            searchedUniversities = universities.filter({ university in
                university.name.localizedCaseInsensitiveContains(text)
                    || university.department.localizedCaseInsensitiveContains(text)
                    || university.city.localizedCaseInsensitiveContains(text)
                    || university.language.localizedCaseInsensitiveContains(text)
            })
        }
        else {
            searchedUniversities = nil
        }
    }
    
    
}
