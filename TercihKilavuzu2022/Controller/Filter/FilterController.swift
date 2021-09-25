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
    var selectedCities: [City]?
    var selectedDepartments: [Department]?
    
    weak var delegate: FilterControllerDelegate?
    
    // MARK: - Subviews
    
    private let cityListView = CityListView()
    private let departmentListView = DepartmentListView()
    private var scholarshipView : ScholarshipView?
    private var universityTypeView : StatePrivateView?
    private var languageTypeView : LanguageView?
    private var durationTypeView : DurationView?
    private var scoreRangeView : ScoreRangeView?
    private var placementRangeView : PlacementRangeView?
    
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
        let vc = CityListController()
        vc.delegate = self
        vc.selectedCities = selectedCities ?? [City]()
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
    
    @objc func handleDepartmentTapped() {
        let vc = DepartmentListController()
        vc.delegate = self
        vc.selectedDepartments = selectedDepartments ?? [Department]()
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
    
    @objc func handleSaveFilterTapped() {
        selectedFilters.removeAll() // delete all filters first
        
        selectedFilters.append(contentsOf: scholarshipView!.filterScholarshipOptions)
        selectedFilters.append(contentsOf: universityTypeView!.statePrivateFilterOptions)
        selectedFilters.append(contentsOf: languageTypeView!.languageFilterOptions)
        selectedFilters.append(contentsOf: durationTypeView!.durationFilterOptions)
        minScore = Double(scoreRangeView?.minScoreField.text ?? "")
        maxScore = Double(scoreRangeView?.maxScoreField.text ?? "")
        minPlacement = Int(placementRangeView?.minPlacementField.text ?? "")
        maxPlacement = Int(placementRangeView?.maxPlacementField.text ?? "")
                
        delegate?.filterUniversities(self)
        navigationController?.popViewController(animated: true)
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
        
        durationTypeView = DurationView(filters: selectedFilters)
        languageTypeView = LanguageView(filters: selectedFilters)
        universityTypeView = StatePrivateView(filters: selectedFilters)
        scholarshipView = ScholarshipView(filters: selectedFilters)
        scoreRangeView = ScoreRangeView(minScore: minScore, maxScore: maxScore)
        placementRangeView = PlacementRangeView(minPlacement: minPlacement, maxPlacement: maxPlacement)
        
        let stack = UIStackView(arrangedSubviews: [cityListView, departmentListView, scholarshipView!,
                                                   universityTypeView!, languageTypeView!, durationTypeView!,
                                                   scoreRangeView!, placementRangeView! ])
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
        scoreRangeView?.minScoreField.resignFirstResponder()
        scoreRangeView?.maxScoreField.resignFirstResponder()
        placementRangeView?.minPlacementField.resignFirstResponder()
        placementRangeView?.maxPlacementField.resignFirstResponder()
    }
}

extension FilterController: CityListDelegate {
    func saveSelectedCities(_ cityListController: CityListController) {
        self.selectedCities = cityListController.selectedCities
    }
}

extension FilterController: DepartmentListDelegate {
    func saveSelectedDepartments(_ departmentListController: DepartmentListController) {
        print("Save button is called in FilterController..")
        self.selectedDepartments = departmentListController.selectedDepartments
    }
}
