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
    
    private var selectedFilters: [FilterOptions]?
    private var minScore: Double?
    private var maxScore: Double?
    private var minPlacement: Int?
    private var maxPlacement: Int?
    
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
    
    private var filteredUniversities: [University]?
    
    private let actionSheetLauncher = ActionSheetLauncher()
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .myCustomBlue
        button.setImage(UIImage(named: "new_tweet"), for: .normal)
//        button.setImage(#imageLiteral(resourceName: "new_tweet"), for: .normal)
        button.addTarget(self, action: #selector(handleFilterButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchUniversities()
        sortUniversities(byOption: .nameAsc)
    }
    
    override func viewDidLayoutSubviews() {
        actionButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: view.frame.width - 56 - 16, paddingBottom: 32, paddingRight: 16, width: 56, height: 56)
        actionButton.layer.cornerRadius = 56 / 2
    }
    
    
    // MARK: - Helpers
    
    func configureUI() {        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UniversityCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.allowsSelection = false
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Arayınız..."
        navigationItem.searchController = searchController
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down"), style: .plain, target: self, action: #selector(handleSortTapped))
        
        view.addSubview(actionButton)
        
        
    }
    
    func sortUniversities(byOption option: ActionSheetOptions) {
        switch option {
        case .nameAsc:
            return universities.sort(by: { $0.name < $1.name })
        case .nameDesc:
            return universities.sort(by: { $0.name > $1.name })
        case .minScoreAsc:
            return universities.sort(by: { $0.minScore < $1.minScore })
        case .minScoreDesc:
            return universities.sort(by: { $0.minScore > $1.minScore })
        case .placementAsc:
            return universities.sort(by: { $0.placement < $1.placement })
        case .placementDesc:
            return universities.sort(by: { $0.placement > $1.placement })
        case .departmentAsc:
            return universities.sort(by: { $0.department < $1.department })
        case .departmenDesc:
            return universities.sort(by: { $0.department > $1.department })
        case .cityAsc:
           return universities.sort(by: { $0.city < $1.city })
        case .cityDesc:
            return universities.sort(by: { $0.city > $1.city })
        case .quotaAsc:
            return universities.sort(by: { $0.quota < $1.quota })
        case .quotaDesc:
            return universities.sort(by: { $0.quota > $1.quota })
        }
    }
    
    func filterUniversitiesWithSelectedFilters() {
        guard let filters = selectedFilters else { return }
        
        filteredUniversities = universities
        
//        if selectedFilters?.contains(.privateUniversities) && !selectedFilters?.contains(.stateUniversities) {
//            filteredUniversities = universities.filter({ $0.type == 1 })
//        }
        
        if filters.contains(.year4) && !filters.contains(.year2) {
            filteredUniversities = filteredUniversities!.filter({ $0.duration == "4" })
        }
        
        if filters.contains(.year2) && !filters.contains(.year4) {
            filteredUniversities = filteredUniversities!.filter({ $0.duration == "2" })
        }
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
//        let nav = UINavigationController(rootViewController: FilterController())
//        nav.modalPresentationStyle = .fullScreen
        let vc = FilterController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func handleSortTapped() {
        actionSheetLauncher.delegate = self
        actionSheetLauncher.show()
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

// MARK: - ActionSheetLauncherDelegate

extension UniversityController: ActionSheetLauncherDelegate {
    func didSelectOption(option: ActionSheetOptions) {
        sortUniversities(byOption: option)
    }
}


extension UniversityController: FilterControllerDelegate {
    func filterUniversities(_ filter: FilterController) {
        selectedFilters = filter.selectedFilters
        minScore = filter.minScore
        maxScore = filter.maxScore
        minPlacement = filter.minPlacement
        maxPlacement = filter.maxPlacement
        
        filterUniversitiesWithSelectedFilters()
    }
}
