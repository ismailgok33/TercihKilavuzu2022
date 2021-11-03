//
//  StatePrivateView.swift
//  TercihKilavuzu2022
//
//  Created by İsmail on 21.09.2021.
//

import UIKit

class StatePrivateView: UIView {
    
    // MARK: - Properties
    
    var statePrivateFilterOptions: [FilterOptions]
    
    private let viewTitle: UILabel = {
        let label = UILabel()
        label.text = "Üniversite Türü"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    private let stateButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .none
        button.setTitle("Devlet", for: .normal)
        button.tintColor = .white
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleStateButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let privateButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .none
        button.setTitle("Özel", for: .normal)
        button.tintColor = .white
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handlePrivateButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let allButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .none
        button.setTitle("Hepsi", for: .normal)
        button.tintColor = .white
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleAllButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    init(filters: [FilterOptions]?) {
        statePrivateFilterOptions = [FilterOptions]()

        super.init(frame: .zero)

        if let filters = filters, filters.count > 0 {
            if filters.contains(.stateUniversities) {
                appendStateOption()
            }
            if filters.contains(.privateUniversities) {
                appendPrivateOption()
            }
            if filters.contains(.allUniversityTypes) {
                appendAllUniversityTypeOption()
            }
            
        }
        else {
            self.statePrivateFilterOptions = [.allUniversityTypes]
        }
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleAllButtonTapped() {
        if statePrivateFilterOptions.contains(.allUniversityTypes) {
            removeAllUniversityTypeOption()
        }
        else {
            appendAllUniversityTypeOption()
        }
    }
    
    @objc func handleStateButtonTapped() {
        if statePrivateFilterOptions.contains(.stateUniversities) {
            removeStateOption()
        }
        else {
            appendStateOption()
        }
    }
    
    @objc func handlePrivateButtonTapped() {
        if statePrivateFilterOptions.contains(.privateUniversities) {
            removePrivateOption()
        }
        else {
            appendPrivateOption()
        }
    }
    
    // MARK: - Helpers
    
    func configureUI() {
//        backgroundColor = .filterBackgroundColor
        backgroundColor = .clear
        if statePrivateFilterOptions.count == 0 || statePrivateFilterOptions.contains(.allUniversityTypes) {
            allButton.tintColor = .selectedFilterColor
            allButton.layer.borderColor = UIColor.selectedFilterColor.cgColor
        }
        
        
        addSubview(viewTitle)
        viewTitle.anchor(top: topAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 12)
        
        let stack = UIStackView(arrangedSubviews: [allButton, stateButton, privateButton])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 10
        addSubview(stack)
        stack.anchor(top: viewTitle.bottomAnchor, left: leftAnchor, right: rightAnchor,
                     paddingTop: 4, paddingLeft: 12, paddingRight: 12)
    }
    
    func checkIfOptionsAreEmpty() {
        if statePrivateFilterOptions.isEmpty {
            appendAllUniversityTypeOption()
        }
    }
    
    func appendAllUniversityTypeOption() {
        statePrivateFilterOptions.removeAll()
        statePrivateFilterOptions.append(.allUniversityTypes)
        allButton.tintColor = .selectedFilterColor
        allButton.layer.borderColor = UIColor.selectedFilterColor.cgColor
        privateButton.tintColor = .white
        privateButton.layer.borderColor = UIColor.white.cgColor
        stateButton.tintColor = .white
        stateButton.layer.borderColor = UIColor.white.cgColor
    }
    
    func removeAllUniversityTypeOption() {
        statePrivateFilterOptions = statePrivateFilterOptions.filter{ $0 != .allUniversityTypes }
        allButton.tintColor = .white
        allButton.layer.borderColor = UIColor.white.cgColor
        checkIfOptionsAreEmpty()
    }
    
    func appendPrivateOption() {
        
        statePrivateFilterOptions.append(.privateUniversities)
        privateButton.tintColor = .selectedFilterColor
        privateButton.layer.borderColor = UIColor.selectedFilterColor.cgColor
        removeAllUniversityTypeOption()

    }
    
    func removePrivateOption() {
        statePrivateFilterOptions = statePrivateFilterOptions.filter{ $0 != .privateUniversities }
        privateButton.tintColor = .white
        privateButton.layer.borderColor = UIColor.white.cgColor
        checkIfOptionsAreEmpty()
    }
    
    func appendStateOption() {
        
        statePrivateFilterOptions.append(.stateUniversities)
        stateButton.tintColor = .selectedFilterColor
        stateButton.layer.borderColor = UIColor.selectedFilterColor.cgColor
        removeAllUniversityTypeOption()
    }
    
    func removeStateOption() {
        statePrivateFilterOptions = statePrivateFilterOptions.filter { $0 != .stateUniversities }
        stateButton.tintColor = .white
        stateButton.layer.borderColor = UIColor.white.cgColor
        checkIfOptionsAreEmpty()
    }
}
