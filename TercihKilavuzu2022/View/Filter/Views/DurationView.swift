//
//  DurationView.swift
//  TercihKilavuzu2022
//
//  Created by İsmail on 21.09.2021.
//

import UIKit

class DurationView: UIView {
    
    // MARK: - Properties
    
    var durationFilterOptions: [FilterOptions]
    
    private let viewTitle: UILabel = {
        let label = UILabel()
        label.text = "Eğitim Süresi"
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
    
    private let yearButton4: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .none
        button.setTitle("4", for: .normal)
        button.tintColor = .white
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleYear4ButtonTapped), for: .touchUpInside)

        return button
    }()
    
    private let yearButton2: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .none
        button.setTitle("2", for: .normal)
        button.tintColor = .white
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleYear2ButtonTapped), for: .touchUpInside)

        return button
    }()
    
    // MARK: - Lifecycle
    
    init(filters: [FilterOptions]?) {
        durationFilterOptions = [FilterOptions]()

        super.init(frame: .zero)

        if let filters = filters, filters.count > 0 {
                if filters.contains(.year4) {
                    appendYear4Option()
                }
                if filters.contains(.year2) {
                    appendYear2Option()
                }
        }
        else {
            self.durationFilterOptions = [.allYears]
        }
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleAllButtonTapped() {
        if durationFilterOptions.contains(.allYears) {
            removeAllDurationOption()
        }
        else {
            appendAllDurationOption()
        }
    }
    
    @objc func handleYear4ButtonTapped() {
        if durationFilterOptions.contains(.year4) {
            removeYear4Option()
        }
        else {
            appendYear4Option()
        }
    }
    
    @objc func handleYear2ButtonTapped() {
        if durationFilterOptions.contains(.year2) {
            removeYear2Option()
        }
        else {
            appendYear2Option()
        }
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        backgroundColor = .filterBackgroundColor
        if durationFilterOptions.count == 0 || durationFilterOptions.contains(.allYears) {
            allButton.tintColor = .red
            allButton.layer.borderColor = UIColor.red.cgColor

        }
       
//        checkIfOptionsAreEmpty()
        
        addSubview(viewTitle)
        viewTitle.anchor(top: topAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 12)
        
        let stack = UIStackView(arrangedSubviews: [allButton, yearButton4, yearButton2])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 10
        addSubview(stack)
        stack.anchor(top: viewTitle.bottomAnchor, left: leftAnchor, right: rightAnchor,
                     paddingTop: 12, paddingLeft: 12, paddingRight: 12)
    }
    
    private func checkIfOptionsAreEmpty() {
        if durationFilterOptions.isEmpty {
            appendAllDurationOption()
        }
    }
    
    private func appendAllDurationOption() {
        durationFilterOptions.removeAll()
        durationFilterOptions.append(.allYears)
        allButton.tintColor = .red
        allButton.layer.borderColor = UIColor.red.cgColor
        yearButton4.tintColor = .white
        yearButton4.layer.borderColor = UIColor.white.cgColor
        yearButton2.tintColor = .white
        yearButton2.layer.borderColor = UIColor.white.cgColor
    }
    
    private func removeAllDurationOption() {
        durationFilterOptions = durationFilterOptions.filter{ $0 != .allYears }
        print("DEBUG: durationFilterOptions after removeALlDurationOptions is \(durationFilterOptions)")
        allButton.tintColor = .white
        allButton.layer.borderColor = UIColor.white.cgColor
        checkIfOptionsAreEmpty()
    }
    
    private func appendYear4Option() {
        
        durationFilterOptions.append(.year4)
        yearButton4.tintColor = .red
        yearButton4.layer.borderColor = UIColor.red.cgColor
        removeAllDurationOption()

    }
    
    private func removeYear4Option() {
        durationFilterOptions = durationFilterOptions.filter{ $0 != .year4 }
        yearButton4.tintColor = .white
        yearButton4.layer.borderColor = UIColor.white.cgColor
        checkIfOptionsAreEmpty()
    }
    
    private func appendYear2Option() {
        
        durationFilterOptions.append(.year2)
        yearButton2.tintColor = .red
        yearButton2.layer.borderColor = UIColor.red.cgColor
        removeAllDurationOption()
    }
    
    private func removeYear2Option() {
        durationFilterOptions = durationFilterOptions.filter { $0 != .year2 }
        yearButton2.tintColor = .white
        yearButton2.layer.borderColor = UIColor.white.cgColor
        checkIfOptionsAreEmpty()
    }
}
