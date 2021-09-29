//
//  AboutController.swift
//  TercihKilavuzu2022
//
//  Created by İsmail on 29.09.2021.
//

import UIKit

class AboutController: UIViewController {
    
    // MARK: - Properties
    
    private let appImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = UIImage(named: "tercih_kilavuzu_image")
        iv.setDimensions(width: 300, height: 300)
        iv.layer.cornerRadius = 300 / 2
        return iv
    }()
    
    private let aboutText: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        label.text = "Tercih Kılavuzu 2022, sınavlara hazırlanırken hayalini kurduğunuz üniversiteler ve bölümler hakkında bilgiler içeren yardımcı bir uygulamadır. Üniversite taban puan, sıralamaları vb gibi bilgiler ÖSYM'den alınmış olup, Tercih Kılavuzu 2022 sadece yardımcı bilgiler içeren lisanslı olmayan bir uygulamadır. Detaylı bilgi için aşağıdaki linkten web sitemizi ziyaret edebilirsiniz."
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var webSitelink: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Tercih Kılavuzu 2022 Web Sitesi", for: .normal)
        button.addTarget(self, action: #selector(goToAppWebSite), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        title = "Hakkında"
        view.backgroundColor = .white
        
        view.addSubview(appImage)
        appImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 20)
        appImage.centerX(inView: view)
        
        view.addSubview(aboutText)
        aboutText.anchor(top: appImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                         paddingTop: 50, paddingLeft: 20, paddingRight: 20)
        
        view.addSubview(webSitelink)
        webSitelink.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor,
                           paddingBottom: 30)
        webSitelink.centerX(inView: view)
    }
    
    
    // MARK: - Selectors
    
    @objc func goToAppWebSite() {
        guard let url = URL(string: "http://www.google.com") else { return }
        UIApplication.shared.open(url)
    }
}
