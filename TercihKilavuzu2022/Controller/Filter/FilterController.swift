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
    var showEmptyScoreAndPlacement = false
    
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

    private let showEmptyScoreAndPlacementLabel: UILabel = {
        let label = UILabel()
        label.text = "Taban Puanı ve Sıralaması olmayanları getir"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .left
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var showEmptyScoreAndPlacementSwitch: UISwitch = {
        let sw = UISwitch()
        sw.setOn(showEmptyScoreAndPlacement, animated: true)
        sw.tintColor = .systemGray
        sw.backgroundColor = .clear
        sw.addTarget(self, action: #selector(handleSwitchChanged), for: .valueChanged)
        return sw
    }()
    
    private lazy var resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setDimensions(width: 60, height: 40)
        button.backgroundColor = UIColor(white: 0, alpha: 0.2)
        button.setTitle("Sıfırla", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.layer.cornerRadius = 40 / 2
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        button.addTarget(self, action: #selector(handleResetButtonTapped), for: .touchUpInside)
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
        
        configureGradientLayer()
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
    
    @objc func handleSwitchChanged() {
        if showEmptyScoreAndPlacementSwitch.isOn {
            showEmptyScoreAndPlacementSwitch.setOn(true, animated: true)
            showEmptyScoreAndPlacement.toggle()
        }
        else {
            showEmptyScoreAndPlacementSwitch.setOn(false, animated: true)
            showEmptyScoreAndPlacement.toggle()
        }
    }
    
    @objc func handleResetButtonTapped() {
        selectedFilters.removeAll()
        minScore = nil
        maxScore = nil
        minPlacement = nil
        maxPlacement = nil
        selectedCities?.removeAll()
        selectedDepartments?.removeAll()
        showEmptyScoreAndPlacement = false
        
        durationTypeView?.handleAllButtonTapped()
        languageTypeView?.handleAllButtonTapped()
        universityTypeView?.handleAllButtonTapped()
        scholarshipView?.handleAllButtonTapped()
        scoreRangeView?.minScoreField.text = nil
        scoreRangeView?.maxScoreField.text = nil
        placementRangeView?.minPlacementField.text = nil
        placementRangeView?.maxPlacementField.text = nil
        showEmptyScoreAndPlacementSwitch.setOn(false, animated: true)
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
//        view.backgroundColor = .filterBackgroundColor
        
        title = "Filtrele"
        
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
        
        let hStack = UIStackView(arrangedSubviews: [showEmptyScoreAndPlacementLabel, showEmptyScoreAndPlacementSwitch])
        hStack.axis = .horizontal
        hStack.alignment = .center
        hStack.distribution = .fillProportionally
//        hStack.spacing = 10
        
        view.addSubview(hStack)
        hStack.anchor(top:stack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingRight: 20)
        
        view.addSubview(resetButton)
        resetButton.anchor(top:showEmptyScoreAndPlacementSwitch.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 70, paddingBottom: 20, paddingRight: 70)
        
    }
    
    func configureGradientLayer() {
        let topColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0, 1]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.frame
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
