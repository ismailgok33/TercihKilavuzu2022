//
//  DepartmentListController.swift
//  TercihKilavuzu2022
//
//  Created by İsmail on 20.09.2021.
//

import UIKit

private let reuseIdentifier =  "departmentCell"

class DepartmentListController: UITableViewController {
    
    // MARK: - Properties
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        configureUI()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .blue

    }
}

// MARK: - TableViewDatasource

extension DepartmentListController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.textLabel?.text = "department \(indexPath.row)"
        return cell
    }
}
