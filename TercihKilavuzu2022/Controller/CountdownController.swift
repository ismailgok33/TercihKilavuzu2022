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
    
    private var tytView: TYTCountdownGraphView!
    private var aytView: AYTCountdownGraphView!
    private var ydtView: YDTCountdownGraphView!
    
    private let countdownTitle: UILabel = {
        let label = UILabel()
        label.text = "Sınavlara kalan süreler"
        label.textColor = .white
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 26)
        return label
    }()
        
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tytView = TYTCountdownGraphView(frame: CGRect(x: 0, y: 0, width: .zero, height: view.frame.height / 3 - 20))
        aytView = AYTCountdownGraphView(frame: CGRect(x: 0, y: 0, width: .zero, height: view.frame.height / 3 - 20))
        ydtView = YDTCountdownGraphView(frame: CGRect(x: 0, y: 0, width: .zero, height: view.frame.height / 3 - 20))
        
//        configureGradientLayer()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tytView.animateCircle()
        aytView.animateCircle()
        ydtView.animateCircle()
    }
    
    // MARK: Helpers
    
    func configureUI() {
        view.backgroundColor = .backgroundColor
        
        
        let stack = UIStackView(arrangedSubviews: [tytView, aytView, ydtView])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .center
        stack.spacing = 20

        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 10)
//        stack.addConstraintsToSafelyFillView(view)
//        stack.anchor(paddingTop: 10, paddingBottom: 20)
        
        view.addSubview(countdownTitle)
        countdownTitle.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10)
        
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
