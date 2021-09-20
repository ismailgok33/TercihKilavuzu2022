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
        view.backgroundColor = .blue
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleDepartmentTapped))
        view.addGestureRecognizer(gesture)
        
        return view
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
     
    // MARK: Helpers
    
    func configureUI() {
        view.backgroundColor = .white

        view.addSubview(cityView)
        cityView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 100)
        
        view.addSubview(departmentView)
        departmentView.anchor(top: cityView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, height: 100)
        
    }
}
