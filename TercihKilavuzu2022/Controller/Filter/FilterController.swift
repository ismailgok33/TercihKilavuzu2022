//
//  FilterController.swift
//  TercihKilavuzu2022
//
//  Created by İsmail on 20.09.2021.
//

import UIKit

class FilterController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var cityView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleCityTapped))
        view.addGestureRecognizer(gesture)
        
        return view
    }()
    
    private lazy var departmentView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleDepartmentTapped))
        view.addGestureRecognizer(gesture)
        
        return view
    }()
    
    private let scholarshipView = ScholarshipView()
    
    private let universityTypeView = StatePrivateView()
    
    private let languageTypeView = LanguageView()
    
    private let durationTypeView = DurationView()
    
    private let scoreRangeView = ScoreRangeView()
    
    private let placementRangeView = PlacementRangeView()
    
    
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
     
    // MARK: Helpers
    
    func configureUI() {
        view.backgroundColor = .filterBackgroundColor

        view.addSubview(cityView)
        cityView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor,
                        height: 75)
        
        view.addSubview(departmentView)
        departmentView.anchor(top: cityView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 75)
        
        view.addSubview(scholarshipView)
        scholarshipView.anchor(top: departmentView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 100)
        
        view.addSubview(universityTypeView)
        universityTypeView.anchor(top: scholarshipView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 100)
        
        view.addSubview(languageTypeView)
        languageTypeView.anchor(top: universityTypeView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 100)
        
        view.addSubview(durationTypeView)
        durationTypeView.anchor(top: languageTypeView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 100)
        
        view.addSubview(scoreRangeView)
        scoreRangeView.anchor(top: durationTypeView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 100)
        
        view.addSubview(placementRangeView)
        placementRangeView.anchor(top: scoreRangeView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 100)
        
        
    }
}
