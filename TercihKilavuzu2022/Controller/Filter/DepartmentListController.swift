//
//  DepartmentListController.swift
//  TercihKilavuzu2022
//
//  Created by İsmail on 20.09.2021.
//

import UIKit

private let reuseIdentifier =  "departmentCell"

protocol DepartmentListDelegate: AnyObject {
    func saveSelectedDepartments(_ departmentListController: DepartmentListController)
}

class DepartmentListController: UITableViewController {
    
    // MARK: - Properties
    
    let searchController = UISearchController()
    
    private var departments = [Department]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private var searchedDepartments: [Department]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var selectedDepartments = [Department]()
    
    weak var delegate: DepartmentListDelegate?
    
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
        fetchDepartments()
    }
    
    // MARK: - Selectors
    
    @objc func handleSaveButtonTapped() {
        delegate?.saveSelectedDepartments(self)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleCancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        tableView.register(DepartmentCell.self, forCellReuseIdentifier: reuseIdentifier)

        searchController.searchBar.searchBarStyle = .default
        searchController.searchBar.searchTextField.backgroundColor = UIColor.white
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Arayınız..."
        navigationItem.searchController = searchController
    }
    
    func loadSelectedDepartments() {
        let selectedDepartmentNames = selectedDepartments.map({ $0.name })
        
        for i in departments.indices {
            if selectedDepartmentNames.contains(departments[i].name) {
                departments[i].isSelected = true
            }
        }
    }
    
    
    // MARK: - API
    
    func fetchDepartments() {
        
        TextService.shared.fetchStaticDepartments { departments in
            self.departments = departments
            self.loadSelectedDepartments()
        }
    }
}

// MARK: - TableViewDatasource

extension DepartmentListController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let searchedDepartments = searchedDepartments {
            return searchedDepartments.count
        }
        return departments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! DepartmentCell
        
        if let searchedDepartments = searchedDepartments {
            cell.department = searchedDepartments[indexPath.row]
            if let department = cell.department {
                if department.isSelected {
                    cell.accessoryType = .checkmark
                    
                    if !selectedDepartments.contains(where: { department in
                        department.id == searchedDepartments[indexPath.row].id
                    }) {
                        selectedDepartments.append(searchedDepartments[indexPath.row])
                    }
                }
                else {
                    cell.accessoryType = .none
                    selectedDepartments = selectedDepartments.filter({ $0.id != searchedDepartments[indexPath.row].id })
                }
            }
        }
        else {
            cell.department = departments[indexPath.row]
            if let department = cell.department {
                if department.isSelected {
                    cell.accessoryType = .checkmark
                    
                    if !selectedDepartments.contains(where: { department in
                        department.id == departments[indexPath.row].id
                    }) {
                        selectedDepartments.append(departments[indexPath.row])
                    }
                }
                else {
                    cell.accessoryType = .none
                    selectedDepartments = selectedDepartments.filter({ $0.id != departments[indexPath.row].id })
                }
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        view.backgroundColor = .systemGroupedBackground
        
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

extension DepartmentListController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if var searchedDepartmentList = searchedDepartments {
            let department = searchedDepartments?[indexPath.row]
            searchedDepartments?[indexPath.row].isSelected = !(department?.isSelected ?? false)
            
            // Toggle isSelected of the main departments array when searched departments array'e element is toggled
            for (index, value) in departments.enumerated() {
                if value.name == department?.name {
                    departments[index].isSelected = !(department?.isSelected ?? false)
                }
            }
        }
        else {
            let department = departments[indexPath.row]
            departments[indexPath.row].isSelected = !department.isSelected
        }
        
        DispatchQueue.main.async {
            tableView.reloadData()
        }
    }
}

// MARK: - UISearchResultsUpdating

extension DepartmentListController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, !text.isEmpty {
            searchedDepartments = departments.filter({ department in
                department.name.localizedCaseInsensitiveContains(text)
            })
        }
        else {
            searchedDepartments = nil
        }
    }
    
}
