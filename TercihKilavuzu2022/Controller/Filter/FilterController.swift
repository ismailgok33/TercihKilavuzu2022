//
//  FilterController.swift
//  TercihKilavuzu2022
//
//  Created by İsmail on 20.09.2021.
//

import UIKit

protocol FilterControllerDelegate: AnyObject {
    func filterUniversities(_ filter: FilterController)
}

class FilterController: UIViewController {
    
    // MARK: - Properties
    
    var selectedFilters = [FilterOptions]()
    var minScore: Double?
    var maxScore: Double?
    var minPlacement: Int?
    var maxPlacement: Int?
    
    weak var delegate: FilterControllerDelegate?
    
    // MARK: - Subviews
    
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
                
//        textField.delegate = self
        
        // call the 'keyboardWillShow' function when the view controller receive the notification that a keyboard is going to be shown
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
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
        selectedFilters.append(contentsOf: scholarshipView.filterScholarshipOptions)
        selectedFilters.append(contentsOf: universityTypeView.statePrivateFilterOptions)
        selectedFilters.append(contentsOf: languageTypeView.languageFilterOptions)
        selectedFilters.append(contentsOf: durationTypeView.durationFilterOptions)
        minScore = Double(scoreRangeView.minScore.text ?? "")
        maxScore = Double(scoreRangeView.maxScore.text ?? "")
        minPlacement = Int(placementRangeView.minPlacement.text ?? "")
        maxPlacement = Int(placementRangeView.maxPlacement.text ?? "")
        
        delegate?.filterUniversities(self)
    }
    
    @objc func handleResetButtonTapped() {
        print("DEBUG: Reset button is tapped in Filter Screen..")
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            // if keyboard size is not available for some reason, dont do anything
            return
        }
        
        // move the root view up by the distance of keyboard height
        self.view.frame.origin.y = 0 - keyboardSize.height
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        // move back the root view origin to zero
        self.view.frame.origin.y = 0
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


extension FilterController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        scoreRangeView.minScore.resignFirstResponder()
        scoreRangeView.maxScore.resignFirstResponder()
        placementRangeView.minPlacement.resignFirstResponder()
        placementRangeView.maxPlacement.resignFirstResponder()
    }
}
