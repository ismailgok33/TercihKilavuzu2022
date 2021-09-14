//
//  FavoritesController.swift
//  TercihKilavuzu2022
//
//  Created by İsmail on 11.09.2021.
//

import UIKit
import RealmSwift

private let reuseIdentifier = "universityCell"

class FavoritesController: UITableViewController {
    
    // MARK: - Properties
    
    let realm = try! Realm()
    
    var favorites: Results<University>? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        loadFavorites()
    }
    
    // MARK: - Helpers
    func configureUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UniversityCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.allowsSelection = false
        
    }
    
    // MARK: - API
    
    private func loadFavorites() {
        favorites = realm.objects(University.self)
    }
}


// MARK: - TableView Delegate/Datasource methods

extension FavoritesController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let favorites = favorites else { return 0 }
        return favorites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UniversityCell
        if let favorites = favorites {
            let fav = favorites[indexPath.row]
            fav.isFavorite = true
            cell.university = fav
            cell.delegate = self
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

// MARK: - UniversityCellDelegate

extension FavoritesController: UniversityCellDelegate {
    func handleFavoriteTapped(_ cell: UniversityCell) {
        guard let favorite = cell.university else { return }
                
        RealmService.shared.saveFavorite(favorite: favorite)
        favorite.isFavorite.toggle()
        cell.university = favorite
                
    }
}
