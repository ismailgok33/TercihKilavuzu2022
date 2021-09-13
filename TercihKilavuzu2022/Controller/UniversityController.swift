//
//  UniversityController.swift
//  TercihKilavuzu2022
//
//  Created by İsmail on 11.09.2021.
//

import UIKit
import RealmSwift

private let reuseIdentifier = "universityCell"

class UniversityController: UITableViewController {
    
    let realm = try! Realm()
    
    // MARK: - Properties
    
    private var universities = [University]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var favorites: Results<University>?
    
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
//        loadFavorites()
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
    }
    
    private func loadFavorites() {
        favorites = realm.objects(University.self)
                
        guard let favorites = favorites else { return }
        
        for favorite in favorites {            
            guard let i = universities.firstIndex(where: {$0.uid == favorite.uid}) else { return }
            universities[i].isFavorite = true
        }
    }
    
    // MARK: - API
    
    func fetchUniversities() {
        FirestoreService.shared.fetchUniversities { universities in
            self.universities = universities
            self.loadFavorites()
        }
    }
    
    
    // MARK: - Selectors
    @objc func handleFilterButtonTapped() {
        print("DEBUG: filter button tapped..")
    }
}

// MARK: - TableView Delegate/Datasource methods
extension UniversityController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return universities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UniversityCell
        cell.university = universities[indexPath.row]
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
        guard let university = cell.university else { return }
                
        RealmService.shared.saveFavorite(favorite: university)
        university.isFavorite.toggle()
        cell.university = university
        
//        loadFavorites()
        
    }
}
