//
//  ScholarshipView.swift
//  TercihKilavuzu2022
//
//  Created by İsmail on 21.09.2021.
//

import UIKit

class ScholarshipView: UIView {
    
    // MARK: - Properties
    
    var filterScholarshipOptions: [FilterOptions]
    
    private let viewTitle: UILabel = {
        let label = UILabel()
        label.text = "Burs Durumu"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        return label
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
    
    private let percentButton100: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .none
        button.setTitle("%100", for: .normal)
        button.tintColor = .white
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handle100PercentButtonTapped), for: .touchUpInside)
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
        button.addTarget(self, action: #selector(handle75PercentButtonTapped), for: .touchUpInside)
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
        button.addTarget(self, action: #selector(handle50PercentButtonTapped), for: .touchUpInside)
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
        button.addTarget(self, action: #selector(handle25PercentButtonTapped), for: .touchUpInside)
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
        button.addTarget(self, action: #selector(handle0PercentButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    
    // MARK: - Lifecycle
    
    init(filters: [FilterOptions]?) {
        filterScholarshipOptions = [FilterOptions]()
        
        super.init(frame: .zero)
        
        if let filters = filters, filters.count > 0 {
            if filters.contains(.scholarship100) {
                append100PercentOption()
            }
            if filters.contains(.scholarship75) {
                appendPercent75Option()
            }
            if filters.contains(.scholarship50) {
                appendPercent50Option()
            }
            if filters.contains(.scholarship25) {
                appendPercent25Option()
            }
            if filters.contains(.scholarship0) {
                appendPercent0Option()
            }
            
        }
        else {
            self.filterScholarshipOptions = [.scholarshipAll]
        }
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    @objc func handleAllButtonTapped() {
        if filterScholarshipOptions.contains(.scholarshipAll) {
            removeAllScholarshipOption()
        }
        else {
            appendAllScholarshipOption()
        }
    }
    
    @objc func handle100PercentButtonTapped() {
        if filterScholarshipOptions.contains(.scholarship100) {
            remove100PercentOption()
        }
        else {
            append100PercentOption()
        }
    }
    
    @objc func handle75PercentButtonTapped() {
        if filterScholarshipOptions.contains(.scholarship75) {
            removePercent75Option()
        }
        else {
            appendPercent75Option()
        }
    }
    
    @objc func handle50PercentButtonTapped() {
        if filterScholarshipOptions.contains(.scholarship50) {
            removePercent50Option()
        }
        else {
            appendPercent50Option()
        }
    }
    
    @objc func handle25PercentButtonTapped() {
        if filterScholarshipOptions.contains(.scholarship25) {
            removePercent25Option()
        }
        else {
            appendPercent25Option()
        }
    }
    
    @objc func handle0PercentButtonTapped() {
        if filterScholarshipOptions.contains(.scholarship0) {
            removePercent0Option()
        }
        else {
            appendPercent0Option()
        }
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        backgroundColor = .filterBackgroundColor
        if filterScholarshipOptions.count == 0 || filterScholarshipOptions.contains(.scholarshipAll) {
            allButton.tintColor = .red
            allButton.layer.borderColor = UIColor.red.cgColor
        }      
        
        addSubview(viewTitle)
        viewTitle.anchor(top: topAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 12)
        
        let stack = UIStackView(arrangedSubviews: [allButton ,percentButton100, percentButton75,
                                                   percentButton50, percentButton25, percentButton0])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 3
        addSubview(stack)
        stack.anchor(top: viewTitle.bottomAnchor, left: leftAnchor, right: rightAnchor,
                     paddingTop: 12, paddingLeft: 12, paddingRight: 12)
        
    }
    
    private func checkIfOptionsAreEmpty() {
        if filterScholarshipOptions.isEmpty {
            appendAllScholarshipOption()
        }
    }
    
    private func appendAllScholarshipOption() {
        filterScholarshipOptions.removeAll()
        filterScholarshipOptions.append(.scholarshipAll)
        allButton.tintColor = .red
        allButton.layer.borderColor = UIColor.red.cgColor
        percentButton100.tintColor = .white
        percentButton100.layer.borderColor = UIColor.white.cgColor
        percentButton75.tintColor = .white
        percentButton75.layer.borderColor = UIColor.white.cgColor
        percentButton50.tintColor = .white
        percentButton50.layer.borderColor = UIColor.white.cgColor
        percentButton25.tintColor = .white
        percentButton25.layer.borderColor = UIColor.white.cgColor
        percentButton0.tintColor = .white
        percentButton0.layer.borderColor = UIColor.white.cgColor
    }
    
    private func removeAllScholarshipOption() {
        filterScholarshipOptions = filterScholarshipOptions.filter{ $0 != .scholarshipAll }
        allButton.tintColor = .white
        allButton.layer.borderColor = UIColor.white.cgColor
        checkIfOptionsAreEmpty()
    }
    
    private func append100PercentOption() {
        
        filterScholarshipOptions.append(.scholarship100)
        percentButton100.tintColor = .red
        percentButton100.layer.borderColor = UIColor.red.cgColor
        removeAllScholarshipOption()

    }
    
    private func remove100PercentOption() {
        filterScholarshipOptions = filterScholarshipOptions.filter{ $0 != .scholarship100 }
        percentButton100.tintColor = .white
        percentButton100.layer.borderColor = UIColor.white.cgColor
        checkIfOptionsAreEmpty()
    }
    
    private func appendPercent75Option() {
        
        filterScholarshipOptions.append(.scholarship75)
        percentButton75.tintColor = .red
        percentButton75.layer.borderColor = UIColor.red.cgColor
        removeAllScholarshipOption()
    }
    
    private func removePercent75Option() {
        filterScholarshipOptions = filterScholarshipOptions.filter { $0 != .scholarship75 }
        percentButton75.tintColor = .white
        percentButton75.layer.borderColor = UIColor.white.cgColor
        checkIfOptionsAreEmpty()
    }
    
    private func appendPercent50Option() {
        
        filterScholarshipOptions.append(.scholarship50)
        percentButton50.tintColor = .red
        percentButton50.layer.borderColor = UIColor.red.cgColor
        removeAllScholarshipOption()
    }
    
    private func removePercent50Option() {
        filterScholarshipOptions = filterScholarshipOptions.filter { $0 != .scholarship50 }
        percentButton50.tintColor = .white
        percentButton50.layer.borderColor = UIColor.white.cgColor
        checkIfOptionsAreEmpty()
    }
    
    private func appendPercent25Option() {
        
        filterScholarshipOptions.append(.scholarship25)
        percentButton25.tintColor = .red
        percentButton25.layer.borderColor = UIColor.red.cgColor
        removeAllScholarshipOption()
    }
    
    private func removePercent25Option() {
        filterScholarshipOptions = filterScholarshipOptions.filter { $0 != .scholarship25 }
        percentButton25.tintColor = .white
        percentButton25.layer.borderColor = UIColor.white.cgColor
        checkIfOptionsAreEmpty()
    }
    
    private func appendPercent0Option() {
        
        filterScholarshipOptions.append(.scholarship0)
        percentButton0.tintColor = .red
        percentButton0.layer.borderColor = UIColor.red.cgColor
        removeAllScholarshipOption()
    }
    
    private func removePercent0Option() {
        filterScholarshipOptions = filterScholarshipOptions.filter { $0 != .scholarship0 }
        percentButton0.tintColor = .white
        percentButton0.layer.borderColor = UIColor.white.cgColor
        checkIfOptionsAreEmpty()
    }
}
