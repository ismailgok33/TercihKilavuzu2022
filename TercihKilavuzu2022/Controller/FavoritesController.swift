//
//  FavoritesController.swift
//  TercihKilavuzu2022
//
//  Created by İsmail on 11.09.2021.
//

import UIKit
import RealmSwift
import GoogleMobileAds

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
    
    private let bannerAd: GADBannerView = {
        let banner = GADBannerView()
        banner.adUnitID = "ca-app-pub-6180320592686930/4022248406"
        banner.load(GADRequest())
        banner.backgroundColor = .secondarySystemBackground
        return banner
    }()
    
    private var interstitialAd: GADInterstitial?

    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        loadFavorites()
        sortFavoritesByNameAsc()
        
        // Adding BannerAD to Subview
        bannerAd.rootViewController = self
        self.navigationController?.view.addSubview(bannerAd)
        
        interstitialAd = createInterstitialAd()
        
//        favorites?.observe({ notification in
//            print("DEBUG: Realm observer is \(notification)")
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        })
    }
    
    override func viewDidLayoutSubviews() {
        guard let tabBarHeight = tabBarController?.tabBar.frame.height else { return }
        bannerAd.frame = CGRect(x: 0, y: view.frame.height - tabBarHeight - BANNER_AD_HEIGHT, width: view.frame.width, height: 50)
        
        guard let tabBarHeight = tabBarController?.tabBar.frame.height else { return }
        tableView.contentInset.bottom = tabBarHeight + BANNER_AD_HEIGHT
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
    
    private func createInterstitialAd() -> GADInterstitial {
        let ad = GADInterstitial(adUnitID: INTERSTITIAL_AD_ID)
        ad.delegate = self
        ad.load(GADRequest())
        return ad
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
        
        if interstitialAd?.isReady == true {
            interstitialAd?.present(fromRootViewController: self)
        }
        
        delegate?.handleFavoriteTappedAtFavoritesController(cell)
    }
}

extension FavoritesController: GADInterstitialDelegate {
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitialAd = createInterstitialAd()
    }
}
