//
//  LanguageView.swift
//  TercihKilavuzu2022
//
//  Created by İsmail on 21.09.2021.
//

import UIKit

class LanguageView: UIView {
    
    // MARK: - Properties
    
    var languageFilterOptions: [FilterOptions]
    
    private let viewTitle: UILabel = {
        let label = UILabel()
        label.text = "Eğitim Dili"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    private lazy var allButton: UIButton = {
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
    
    private lazy var turkishButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .none
        button.setTitle("Türkçe", for: .normal)
        button.tintColor = .white
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleTurkishButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let englishButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .none
        button.setTitle("İngilizce", for: .normal)
        button.tintColor = .white
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleEnglishButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    init(filters: [FilterOptions]?) {
        languageFilterOptions = [FilterOptions]()

        super.init(frame: .zero)

        if let filters = filters, filters.count > 0 {
            if filters.contains(.turkish) {
                appendTurkishLanguageOption()
            }
            if filters.contains(.english) {
                appendEnglishLanguageOption()
            }
            if filters.contains(.allLanguages) {
                appendAllLanguagesOption()
            }
            
        }
        else {
            self.languageFilterOptions = [.allLanguages]
        }
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleAllButtonTapped() {
        if languageFilterOptions.contains(.allLanguages) {
            removeAllLanguagesOption()
        }
        else {
            appendAllLanguagesOption()
        }
    }
    
    @objc func handleTurkishButtonTapped() {
        if languageFilterOptions.contains(.turkish) {
            removeTurkishLanguageOption()
        }
        else {
            appendTurkishLanguageOption()
        }
    }
    
    @objc func handleEnglishButtonTapped() {
        if languageFilterOptions.contains(.english) {
            removeEnglishLanguageOption()
        }
        else {
            appendEnglishLanguageOption()
        }
    }
    
    
    // MARK: - Helpers
    
    func configureUI() {
//        backgroundColor = .filterBackgroundColor
        backgroundColor = .clear
        
        if languageFilterOptions.count == 0 || languageFilterOptions.contains(.allLanguages){
            allButton.tintColor = .red
            allButton.layer.borderColor = UIColor.red.cgColor

        }
//        checkIfOptionsAreEmpty()
        
        addSubview(viewTitle)
        viewTitle.anchor(top: topAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 12)
        
        let stack = UIStackView(arrangedSubviews: [allButton, turkishButton, englishButton])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 10
        addSubview(stack)
        stack.anchor(top: viewTitle.bottomAnchor, left: leftAnchor, right: rightAnchor,
                     paddingTop: 12, paddingLeft: 12, paddingRight: 12)
    }
    
    func checkIfOptionsAreEmpty() {
        if languageFilterOptions.isEmpty {
            appendAllLanguagesOption()
        }
    }
    
    func appendAllLanguagesOption() {
        languageFilterOptions.removeAll()
        languageFilterOptions.append(.allLanguages)
        allButton.tintColor = .red
        allButton.layer.borderColor = UIColor.red.cgColor
        turkishButton.tintColor = .white
        turkishButton.layer.borderColor = UIColor.white.cgColor
        englishButton.tintColor = .white
        englishButton.layer.borderColor = UIColor.white.cgColor
    }
    
    func removeAllLanguagesOption() {
        languageFilterOptions = languageFilterOptions.filter{ $0 != .allLanguages }
        allButton.tintColor = .white
        allButton.layer.borderColor = UIColor.white.cgColor
        checkIfOptionsAreEmpty()
    }
    
    func appendTurkishLanguageOption() {
        
        languageFilterOptions.append(.turkish)
        turkishButton.tintColor = .red
        turkishButton.layer.borderColor = UIColor.red.cgColor
        removeAllLanguagesOption()

    }
    
    func removeTurkishLanguageOption() {
        languageFilterOptions = languageFilterOptions.filter{ $0 != .turkish }
        turkishButton.tintColor = .white
        turkishButton.layer.borderColor = UIColor.white.cgColor
        checkIfOptionsAreEmpty()
    }
    
    func appendEnglishLanguageOption() {
        
        languageFilterOptions.append(.english)
        englishButton.tintColor = .red
        englishButton.layer.borderColor = UIColor.red.cgColor
        removeAllLanguagesOption()
    }
    
    func removeEnglishLanguageOption() {
        languageFilterOptions = languageFilterOptions.filter { $0 != .english }
        englishButton.tintColor = .white
        englishButton.layer.borderColor = UIColor.white.cgColor
        checkIfOptionsAreEmpty()
    }
}
