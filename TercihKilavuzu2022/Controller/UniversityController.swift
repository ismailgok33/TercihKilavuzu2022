//
//  UniversityController.swift
//  TercihKilavuzu2022
//
//  Created by İsmail on 11.09.2021.
//

import UIKit
import RealmSwift
import GoogleMobileAds

private let reuseIdentifier = "universityCell"

protocol UniversityControllerDelegate: AnyObject {
    func handleFavoriteTappedAtUniversityController(_ cell: UniversityCell)
}

class UniversityController: UITableViewController {
    
    // MARK: - Properties
    
    let realm = try! Realm()
    
    let searchController = UISearchController()
    
    private var selectedFilters: [FilterOptions]?
    private var minScore: Double?
    private var maxScore: Double?
    private var minPlacement: Int?
    private var maxPlacement: Int?
    private var selectedCities = [City]()
    private var selectedDepartments = [Department]()
    private var showEmptyScoreAndPlacement = false
    private var lastContentOffset: CGFloat = 0
    
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
    
    private var filteredUniversities = [University](){
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private let actionSheetLauncher = ActionSheetLauncher()
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = #colorLiteral(red: 0.5336218476, green: 0.9556542039, blue: 0.8722702861, alpha: 1)
//        let config = UIImage.SymbolConfiguration(pointSize: 50, weight: .bold, scale: .large)
//        button.setImage(UIImage(systemName: "pencil.circle", withConfiguration: config), for: .normal)
        button.setImage(#imageLiteral(resourceName: "filter-icon-50"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.addTarget(self, action: #selector(handleFilterButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var scrollTopActionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = #colorLiteral(red: 0.6278412938, green: 0.9580132365, blue: 0.9230172038, alpha: 1)
        button.setImage(UIImage(systemName: "arrow.up"), for: .normal)
        button.addTarget(self, action: #selector(handleScrollToTop), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    let bannerAd: GADBannerView = {
        let banner = GADBannerView()
        banner.adUnitID = BANNER_AD_ID
        banner.load(GADRequest())
        banner.backgroundColor = .lightGray
        return banner
    }()
    
    private var interstitialAd: GADInterstitial?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchUniversities()
        sortUniversities(byOption: .nameAsc)
        selectedFilters = [.allYears, .allLanguages, .scholarshipAll, .allUniversityTypes]
        interstitialAd = createInterstitialAd()
                
        NotificationCenter.default.addObserver(forName: NSNotification.Name("statusBarSelected"), object: nil, queue: nil) { event in
            // scroll to top of a table view
            self.handleScrollToTop()
        }

    }
    
    override func viewDidLayoutSubviews() {
        actionButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: view.frame.width - 56 - 16, paddingBottom: 16 + BANNER_AD_HEIGHT, paddingRight: 16, width: 56, height: 56)
        actionButton.layer.cornerRadius = 56 / 2
        
        scrollTopActionButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 16, paddingBottom: 16 + BANNER_AD_HEIGHT, paddingRight: view.frame.width - 56 - 16, width: 56, height: 56)
        scrollTopActionButton.layer.cornerRadius = 56 / 2
        
        guard let tabBarHeight = tabBarController?.tabBar.frame.height else { return }
        bannerAd.frame = CGRect(x: 0, y: view.frame.height - tabBarHeight - BANNER_AD_HEIGHT, width: view.frame.width, height: 50)
        
        guard let tabBarHeight = tabBarController?.tabBar.frame.height else { return }
        tableView.contentInset.bottom = tabBarHeight + BANNER_AD_HEIGHT
    }
    
    override func viewWillAppear(_ animated: Bool) {
        bannerAd.isHidden = false
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UniversityCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.allowsSelection = false
        
        searchController.searchBar.searchBarStyle = .default
        searchController.searchBar.searchTextField.backgroundColor = UIColor.white
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Arayınız..."
        navigationItem.searchController = searchController
        
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down"), style: .plain, target: self, action: #selector(handleSortTapped))
        
        view.addSubview(actionButton)
        view.addSubview(scrollTopActionButton)
        
        bannerAd.rootViewController = self
        self.navigationController?.view.addSubview(bannerAd)
    }
    
    func sortUniversities(byOption option: ActionSheetOptions) {
        
        switch option {
        case .nameAsc:
            return filteredUniversities.sort(by: { $0.name.localizedCompare($1.name) == .orderedAscending  })
        case .nameDesc:
            return filteredUniversities.sort(by: { $0.name.localizedCompare($1.name) == .orderedDescending })
        case .minScoreAsc:
            return filteredUniversities.sort(by: { $0.minScore < $1.minScore })
        case .minScoreDesc:
            return filteredUniversities.sort(by: { $0.minScore > $1.minScore })
        case .placementAsc:
            return filteredUniversities.sort(by: { $0.placement < $1.placement })
        case .placementDesc:
            return filteredUniversities.sort(by: { $0.placement > $1.placement })
        case .departmentAsc:
            return filteredUniversities.sort(by: { $0.department.localizedCompare($1.department) == .orderedAscending })
        case .departmenDesc:
            return filteredUniversities.sort(by: { $0.department.localizedCompare($1.department) == .orderedDescending})
        case .cityAsc:
           return filteredUniversities.sort(by: { $0.city < $1.city })
        case .cityDesc:
            return filteredUniversities.sort(by: { $0.city > $1.city })
        case .quotaAsc:
            return filteredUniversities.sort(by: { $0.quota < $1.quota })
        case .quotaDesc:
            return filteredUniversities.sort(by: { $0.quota > $1.quota })
        }
    }
    
    func filterUniversitiesWithSelectedFilters() {
        guard let filters = selectedFilters else { return }
        
        if showEmptyScoreAndPlacement {
            filteredUniversities = universities
        }
        else {
            filteredUniversities = hideEmptyScoreAndPlacement()
        }
                
        let selectedCityNames = selectedCities.map({ $0.name })
        let selectedDepartmentNames = selectedDepartments.map({ $0.name })
        
        if filters.contains(.year4) && !filters.contains(.year2) {
            filteredUniversities = filteredUniversities.filter({ $0.duration == "4" })
        }
        
        if filters.contains(.year2) && !filters.contains(.year4) {
            filteredUniversities = filteredUniversities.filter({ $0.duration == "2" })
        }
        
        if filters.contains(.english) && !filters.contains(.turkish) {
            filteredUniversities = filteredUniversities.filter({ $0.language == "İngilizce"})
        }
        
        if filters.contains(.turkish) && !filters.contains(.english) {
            filteredUniversities = filteredUniversities.filter({ $0.language == "Türkçe"})
        }
        
        if filters.contains(.stateUniversities) && !filters.contains(.privateUniversities) {
            filteredUniversities = filteredUniversities.filter({ $0.state == true})
        }
        
        if filters.contains(.privateUniversities) && !filters.contains(.stateUniversities) {
            filteredUniversities = filteredUniversities.filter({ $0.state == false})
        }
        
        let filteredUniversitiesBeforeScholarFilter = filteredUniversities
        
        if !filters.contains(.scholarship100) {
            filteredUniversities = filteredUniversities.filter({ $0.scholarship != "%100 Burslu" && $0.scholarship != ""})
        }
        
        if !filters.contains(.scholarship75) {
            filteredUniversities = filteredUniversities.filter({ $0.scholarship != "%75 Burslu" && $0.scholarship != ""})
        }
        
        if !filters.contains(.scholarship50) {
            filteredUniversities = filteredUniversities.filter({ $0.scholarship != "%50 Burslu" && $0.scholarship != ""})
        }
        
        if !filters.contains(.scholarship25) {
            filteredUniversities = filteredUniversities.filter({ $0.scholarship != "%25 Burslu" && $0.scholarship != ""})
        }
        
        if !filters.contains(.scholarship0) {
            filteredUniversities = filteredUniversities.filter({ $0.scholarship != "%0 Burslu" && $0.scholarship != ""})
        }
        
        if filters.contains(.scholarshipAll) {
            filteredUniversities = filteredUniversitiesBeforeScholarFilter
        }
        
        if let safeMinScore = minScore {
            filteredUniversities = filteredUniversities.filter({ $0.minScore >= safeMinScore })
        }
        
        if let safeMaxScore = maxScore {
            filteredUniversities = filteredUniversities.filter({ $0.minScore <= safeMaxScore })
        }
        
        if let safeMinPlacement = minPlacement {
            filteredUniversities = filteredUniversities.filter({ $0.placement >= safeMinPlacement })
        }
        
        if let safeMaxPlacement = maxPlacement {
            filteredUniversities = filteredUniversities.filter({ $0.placement <= safeMaxPlacement })
        }
                
        if selectedCityNames.count > 0 {
            filteredUniversities.forEach({ university in
                if !selectedCityNames.contains(university.city) {
                    filteredUniversities = filteredUniversities.filter({ $0 != university })
                }
            })
        }
        
        if selectedDepartmentNames.count > 0 {
            filteredUniversities.forEach({ university in
                if !selectedDepartmentNames.contains(university.department) {
                    filteredUniversities = filteredUniversities.filter({ $0 != university })
                }
            })
        }
    }
    
    func hideEmptyScoreAndPlacement() -> [University] {
        return universities.filter({ $0.minScore > 0 && $0.placement > 0 })
    }
    
    func createInterstitialAd() -> GADInterstitial {
        let ad = GADInterstitial(adUnitID: INTERSTITIAL_AD_ID)
        ad.delegate = self
        ad.load(GADRequest())
        return ad
    }
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return UIStatusBarStyle.darkContent
//    }
    
    
    // MARK: - API
    
    func fetchUniversities() {
//        FirestoreService.shared.fetchUniversities { universities in
//            self.universities = universities
//            self.filteredUniversities = universities
//            self.loadFavorites()
//        }
        
        FirestoreService.shared.fetchStaticUniversities { universities in
            self.universities = universities
            self.filteredUniversities = self.hideEmptyScoreAndPlacement()
            print("DEBUG: filteredUniversities is \(self.filteredUniversities)")
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
        bannerAd.isHidden = true
        
        let vc = FilterController()
        vc.selectedFilters = selectedFilters ?? [FilterOptions]()
        vc.minScore = minScore
        vc.maxScore = maxScore
        vc.minPlacement = minPlacement
        vc.maxPlacement = maxPlacement
        vc.selectedCities = selectedCities
        vc.selectedDepartments = selectedDepartments
        vc.showEmptyScoreAndPlacement = showEmptyScoreAndPlacement
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func handleSortTapped() {
        actionSheetLauncher.delegate = self
        actionSheetLauncher.show()
    }
    
    @objc func handleScrollToTop() {
        tableView.setContentOffset(.zero, animated: true)
        scrollTopActionButton.isHidden = true
    }
}

// MARK: - TableView Delegate/Datasource methods

extension UniversityController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let searchedUniversities = searchedUniversities {
            return searchedUniversities.count
        }
        else {
            return filteredUniversities.count
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UniversityCell
        if let searchedUniversities = searchedUniversities {
            cell.university = searchedUniversities[indexPath.row]
        }
        else {
            cell.university = filteredUniversities[indexPath.row]
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
        
        if interstitialAd?.isReady == true {
            interstitialAd?.present(fromRootViewController: self)
        }
        
        delegate?.handleFavoriteTappedAtUniversityController(cell)
    }
}

// MARK: - ScrollView Extentions

extension UniversityController {
//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView == tableView {
//            scrollTopActionButton.isHidden = scrollView.contentOffset.y > 50
//        }
//    }
    
//    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        let targetPoint = targetContentOffset as? CGPoint
//        let currentPoint = scrollView.contentOffset
//
//        if (targetPoint?.y ?? 0.0) > currentPoint.y {
//            scrollTopActionButton.isHidden = false
//        }
//        else {
//            scrollTopActionButton.isHidden = true
//        }
//    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.lastContentOffset > scrollView.contentOffset.y && scrollView.contentOffset.y > 100) {
            scrollTopActionButton.isHidden = false
        }
        else if (self.lastContentOffset < scrollView.contentOffset.y) {
            scrollTopActionButton.isHidden = true
        }
        
        self.lastContentOffset = scrollView.contentOffset.y
    }
}

// MARK: - UISearchResultsUpdating

extension UniversityController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, !text.isEmpty {
            searchedUniversities = filteredUniversities.filter({ university in
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

// MARK: - ActionSheetLauncherDelegate

extension UniversityController: ActionSheetLauncherDelegate {
    func didSelectOption(option: ActionSheetOptions) {
        sortUniversities(byOption: option)
    }
}

// MARK: - FilterControllerDelegate

extension UniversityController: FilterControllerDelegate {
    func filterUniversities(_ filter: FilterController) {
//        bannerAd.isHidden = false
        
        selectedFilters = filter.selectedFilters
        minScore = filter.minScore
        maxScore = filter.maxScore
        minPlacement = filter.minPlacement
        maxPlacement = filter.maxPlacement
        selectedCities = filter.selectedCities ?? [City]()
        selectedDepartments = filter.selectedDepartments ?? [Department]()
        showEmptyScoreAndPlacement = filter.showEmptyScoreAndPlacement
                
        filterUniversitiesWithSelectedFilters()
    }
}

// MARK: - GADInterstitialDelegate

extension UniversityController: GADInterstitialDelegate {
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitialAd = createInterstitialAd()
    }
}
