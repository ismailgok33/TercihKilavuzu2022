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
        banner.backgroundColor = .lightGray
        return banner
    }()
    
    private let emptyImage: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "no-favorites")
        iv.contentMode = .scaleAspectFit
        iv.setDimensions(width: 400, height: 400)
        return iv
    }()
    
    private var interstitialAd: GADInterstitial?
    private var deletePlanetIndexPath: IndexPath? = nil


    
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
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UniversityCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.allowsSelection = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(handleShareTapped))
        
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
    
//    func confirmDelete(_ favorite: University) {
//        let alert = UIAlertController(title: "Emin misiniz?", message: "Favorilerden silmek istediğinizden emin misiniz?", preferredStyle: .actionSheet)
//        let deleteAction = UIAlertAction(title: "Sil", style: .destructive, handler: handleDeleteFavorite)
//        let cancelAction = UIAlertAction(title: "Vazgeç", style: .cancel, handler: handleCancelDeleteAction)
//
//        alert.addAction(deleteAction)
//        alert.addAction(cancelAction)
//
//        // Support display in iPad
//        alert.popoverPresentationController?.sourceView = self.view
//        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
//        self.present(alert, animated: true, completion: nil)
//
//    }
    
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
    
    @objc func handleShareTapped() {
        // text to share
        var favoriteTextList = ""
        
        favorites?.forEach({ favorite in
            favoriteTextList += "- \(favorite.name) / \(favorite.department) \n"
        })
        
        if favoriteTextList == "" {
            let alert = UIAlertController(title: "Uyarı", message: "Paylaşılacak favori bulunamadı", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            let textToShare = [ favoriteTextList ]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
            
            activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
                        
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
//    func handleDeleteFavorite(alertAction: UIAlertAction) -> Void {
//        guard let deleteIndex = deletePlanetIndexPath else { return }
//        guard let favorite = favorites?[deleteIndex.row] else { return }
//        favorite.isFavorite = true
////        tableView.beginUpdates()
//        RealmService.shared.saveFavorite(favorite: favorite)
//        tableView.reloadData()
////        tableView.deleteRows(at: [deleteIndex], with: .automatic)
//        deletePlanetIndexPath = nil
////        tableView.endUpdates()
//    }

//    func handleCancelDeleteAction(alertAction: UIAlertAction) -> Void {
//        deletePlanetIndexPath = nil
//    }
}


// MARK: - TableView Delegate/Datasource methods

extension FavoritesController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let favorites = favorites else { return 0 }
        if favorites.count == 0 {
            tableView.backgroundView = emptyImage
            emptyImage.frame = CGRect(x: view.frame.width / 2 - 200, y: view.frame.height / 2 - 200, width: 400, height: 400)
            tableView.separatorStyle = .none
            tableView.isUserInteractionEnabled = false
        }
        else {
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
            tableView.isUserInteractionEnabled = true
        }
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
        return 130
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let favorites = favorites else { return }
            
            let favorite = favorites[indexPath.row]
            favorite.isFavorite = true
    //        tableView.beginUpdates()
//            RealmService.shared.saveFavorite(favorite: favorite)
            delegate?.handleFavoriteTappedAtFavoritesController(tableView.cellForRow(at: indexPath) as! UniversityCell)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            if interstitialAd?.isReady == true {
                interstitialAd?.present(fromRootViewController: self)
            }
            deletePlanetIndexPath = nil
    //        tableView.endUpdates()
        }
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


// MARK: - GADInterstitialDelegate

extension FavoritesController: GADInterstitialDelegate {
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitialAd = createInterstitialAd()
    }
}
