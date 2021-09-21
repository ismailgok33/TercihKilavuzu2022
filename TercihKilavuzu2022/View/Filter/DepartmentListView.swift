//
//  DepartmentListView.swift
//  TercihKilavuzu2022
//
//  Created by İsmail on 21.09.2021.
//

import UIKit

class DepartmentListView: UIView {
    
    // MARK: - Properties
    
    private let viewTitle: UILabel = {
        let label = UILabel()
        label.text = "Bölümler"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        backgroundColor = UIColor(white: 1, alpha: 0.2)
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
        layer.cornerRadius = 5
        
        addSubview(viewTitle)
        viewTitle.centerY(inView: self)
        viewTitle.anchor(left: leftAnchor, paddingLeft: 12)
    }
}
