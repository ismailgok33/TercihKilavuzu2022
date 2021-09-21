//
//  FilterController.swift
//  TercihKilavuzu2022
//
//  Created by İsmail on 20.09.2021.
//

import UIKit

class FilterController: UIViewController {
    
    // MARK: - Properties
    
    private let cityListView = CityListView()
    
    private let departmentListView = DepartmentListView()
    
    private let scholarshipView = ScholarshipView()
    
    private let universityTypeView = StatePrivateView()
    
    private let languageTypeView = LanguageView()
    
    private let durationTypeView = DurationView()
    
    private let scoreRangeView = ScoreRangeView()
    
    private let placementRangeView = PlacementRangeView()
    
    private let resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setDimensions(width: 100, height: 50)
        button.backgroundColor = UIColor(white: 0, alpha: 0.2)
        button.setTitle("Sıfırla", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.layer.cornerRadius = 50 / 2
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Selectors
    
    @objc func handleCityTapped() {
        let nav = UINavigationController(rootViewController: CityListController())
        present(nav, animated: true, completion: nil)
    }
    
    @objc func handleDepartmentTapped() {
        let nav = UINavigationController(rootViewController: DepartmentListController())
        present(nav, animated: true, completion: nil)
    }
    
    @objc func handleSaveFilterTapped() {
        print("DEBUG: Save button is tapped in Filter Screen..")
    }
    
    @objc func handleResetButtonTapped() {
        print("DEBUG: Reset button is tapped in Filter Screen..")
    }
     
    // MARK: Helpers
    
    func configureUI() {
        view.backgroundColor = .filterBackgroundColor
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filtrele", style: .done, target: self, action: #selector(handleSaveFilterTapped))
        
        let stack = UIStackView(arrangedSubviews: [cityListView, departmentListView, scholarshipView,
                                                   universityTypeView, languageTypeView, durationTypeView,
                                                   scoreRangeView, placementRangeView ])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        
        let cityTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCityTapped))
        cityListView.addGestureRecognizer(cityTapGesture)
        
        let departmentTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDepartmentTapped))
        departmentListView.addGestureRecognizer(departmentTapGesture)
        
        view.addSubview(stack)
        stack.anchor(top:view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
//        stack.addConstraintsToSafelyFillView(view)
        
        view.addSubview(resetButton)
        resetButton.anchor(top:stack.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor,
                           paddingTop: 20, paddingLeft: 25, paddingBottom: 20, paddingRight: 25)
        
    }
}
