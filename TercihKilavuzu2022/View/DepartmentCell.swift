//
//  DepartmentCell.swift
//  TercihKilavuzu2022
//
//  Created by İsmail on 21.09.2021.
//

import UIKit

class DepartmentCell: UITableViewCell {
    
    // MARK: - Properties
    
    var department: Department? {
        didSet {
            configure()
        }
    }
    
    private let departmentName: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "test department"
        return label
    }()
    
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(departmentName)
        departmentName.centerY(inView: self)
        departmentName.anchor(left: leftAnchor, paddingLeft: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Helpers
    func configure() {
        departmentName.text = department?.name
    }
}
