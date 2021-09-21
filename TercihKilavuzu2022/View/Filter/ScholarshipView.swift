//
//  ScholarshipView.swift
//  TercihKilavuzu2022
//
//  Created by İsmail on 21.09.2021.
//

import UIKit

class ScholarshipView: UIView {
    
    // MARK: - Properties
    
    private let viewTitle: UILabel = {
        let label = UILabel()
        label.text = "Burs Durumu"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    private let percentButton100: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .none
        button.setTitle("%100", for: .normal)
        button.tintColor = .white
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 5
        return button
    }()
    
    private let percentButton75: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .none
        button.setTitle("%75", for: .normal)
        button.tintColor = .white
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 5
        return button
    }()
    
    private let percentButton50: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .none
        button.setTitle("%50", for: .normal)
        button.tintColor = .white
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 5
        return button
    }()
    
    private let percentButton25: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .none
        button.setTitle("%25", for: .normal)
        button.tintColor = .white
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 5
        return button
    }()
    
    private let percentButton0: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .none
        button.setTitle("%0", for: .normal)
        button.tintColor = .white
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 5
        return button
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
        backgroundColor = .filterBackgroundColor
        
        addSubview(viewTitle)
        viewTitle.anchor(top: topAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 12)
        
        let stack = UIStackView(arrangedSubviews: [percentButton100, percentButton75,
                                                   percentButton50, percentButton25, percentButton0])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 5
        addSubview(stack)
        stack.anchor(top: viewTitle.bottomAnchor, left: leftAnchor, right: rightAnchor,
                     paddingTop: 12, paddingLeft: 12, paddingRight: 12)
        
    }
}
