//
//  CountdownController.swift
//  TercihKilavuzu2022
//
//  Created by İsmail on 11.09.2021.
//

import UIKit
import GoogleMobileAds

class CountdownController: UIViewController {
    
    // MARK: - Properties
    
    private var tytCountdownGraphView = TYTCountdownGraphView()
    private var aytCountdownGraphView = AYTCountdownGraphView()
    private var ydtCountdownGraphView = YDTCountdownGraphView()
    
    private let tytLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "TYT"
        label.textColor = .white
        return label
    }()
    
    private let aytLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "AYT"
        label.textColor = .white
        return label
    }()
    
    private let ydtLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "YDT"
        label.textColor = .white
        return label
    }()
    
    private let seperator: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureGradientLayer()
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        seperator.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 1)
    }
    
    // MARK: Helpers
    
    func configureUI() {
//        view.backgroundColor = .red
        
        
        let tytStack = UIStackView(arrangedSubviews: [tytLabel, tytCountdownGraphView])
//        tytStack.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        tytStack.axis = .vertical
        tytStack.alignment = .center
        tytStack.spacing = -10
//        tytStack.backgroundColor = .red
        
        let aytStack = UIStackView(arrangedSubviews: [aytLabel, aytCountdownGraphView])
        aytStack.axis = .vertical
        aytStack.alignment = .center
        aytStack.spacing = -10
//        aytStack.backgroundColor = .blue
        
        let ydtStack = UIStackView(arrangedSubviews: [ydtLabel, ydtCountdownGraphView])
        ydtStack.axis = .vertical
        ydtStack.alignment = .center
        ydtStack.spacing = -10
//        ydtStack.backgroundColor = .green
    
        
        let stack = UIStackView(arrangedSubviews: [tytStack, seperator, aytStack, seperator, ydtStack])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .center
        stack.spacing = 20

        view.addSubview(stack)
//        stack.frame = view.frame
        stack.addConstraintsToSafelyFillView(view)
        stack.anchor(paddingTop: 20, paddingBottom: 20)
//        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .plain, target: self, action: #selector(handleAboutButtonTapped))
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
    
    
    // MARK: - Selectors
    
    @objc func handleAboutButtonTapped() {
        navigationController?.pushViewController(AboutController(), animated: true)
    }
    
    
}

// MARK: - NSObject extension for copying a class

extension NSObject {
    func copyObject<T:NSObject>() throws -> T? {
        let data = try NSKeyedArchiver.archivedData(withRootObject:self, requiringSecureCoding:false)
        return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? T
    }
}
