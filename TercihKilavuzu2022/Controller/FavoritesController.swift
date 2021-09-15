//
//  FavoritesController.swift
//  TercihKilavuzu2022
//
//  Created by İsmail on 11.09.2021.
//

import UIKit
import RealmSwift

private let reuseIdentifier = "favoriteCell"

protocol FavoritesControllerDelegate: AnyObject {
    func handleFavoriteTappedAtFavoritesController(_ cell: UniversityCell)
}

class FavoritesController: UITableViewController {
    
    // MARK: - Properties
    
    let realm = try! Realm()
    
    weak var delegate: FavoritesControllerDelegate?
    
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
        sortFavoritesByNameAsc()
        
//        favorites?.observe({ notification in
//            print("DEBUG: Realm observer is \(notification)")
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        })
    }
    
    // MARK: - Helpers
    func configureUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UniversityCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.allowsSelection = false
        
        let refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    func sortFavoritesByNameAsc() {
        
        favorites = favorites?.sorted(byKeyPath: "name", ascending: true)
    }
    
    // MARK: - API
    
     func loadFavorites() {
        refreshControl?.beginRefreshing()
        favorites = realm.objects(University.self)
        sortFavoritesByNameAsc()
        refreshControl?.endRefreshing()
    }
    
    // MARK: - Selectors
    
    @objc func handleRefresh() {
        loadFavorites()
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
        
        delegate?.handleFavoriteTappedAtFavoritesController(cell)
        
//        guard let favorite = cell.university else { return }
//        favorite.isFavorite = true
//        RealmService.shared.saveFavorite(favorite: favorite)
//        favorite.isFavorite.toggle()
//        //cell.university = favorite
//        loadFavorites()
    }
}
