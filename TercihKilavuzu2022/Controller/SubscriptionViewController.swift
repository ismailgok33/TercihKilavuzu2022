//
//  SubscriptionController.swift
//  TercihKilavuzu2022
//
//  Created by İsmail on 13.10.2021.
//

import UIKit

class SubscriptionViewController: UIViewController {
    
    // MARK: - Properties
    
   let headerView = SubscriptionHeaderView()
    
    let subscribeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Purchase", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    
    let restoreButton: UIButton = {
        let button = UIButton()
        button.setTitle("Restore Purchase", for: .normal)
        button.setTitleColor(.link, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    
    private let termsOfServiceView: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.textAlignment = .center
        tv.font = .systemFont(ofSize: 12)
        tv.backgroundColor = .white
        tv.textColor = .systemGray
        tv.text = "Bu bir kerelik satın alımdır. Satın alımla beraber uygulamayı reklamsız ve internet olmadan kullanabilirsiniz. Cihaz değiştirmeniz durumunda yeni cihazınıza satın alımı yaptığınız Apple hesabınızla giriş yaptıysanız 'Restore Purchases' butonuna basarak satın alımınızı yeni cihazınıza aktarabilirsiniz."
        return tv
    }()
    
    private let descriptionView = SubscriptionDescriptionView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: view.frame.height / 3)
        termsOfServiceView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor,
                                  paddingLeft: 20, paddingRight: 20, height: 150)
        restoreButton.anchor(left: view.leftAnchor, bottom: termsOfServiceView.topAnchor, right: view.rightAnchor,
                             paddingLeft: 40, paddingBottom: 10, paddingRight: 40, height: 50)
        subscribeButton.anchor(left: view.leftAnchor, bottom: restoreButton.topAnchor, right: view.rightAnchor,
                               paddingLeft: 40, paddingBottom: 10, paddingRight: 40, height: 50)
        descriptionView.anchor(top: headerView.bottomAnchor, left: view.leftAnchor, bottom: restoreButton.topAnchor, right: view.rightAnchor,
                               paddingTop: (view.frame.height - headerView.frame.height - restoreButton.frame.height - subscribeButton.frame.height) / 4)
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        title = "Premium"
        
        view.addSubview(headerView)
        view.addSubview(subscribeButton)
        view.addSubview(restoreButton)
        view.addSubview(termsOfServiceView)
        view.addSubview(descriptionView)
        
        setUpCloseButton()
        setUpButtons()
    }
    
    private func setUpCloseButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(handleCloseView))
    }
    
    private func setUpButtons() {
        subscribeButton.addTarget(self, action: #selector(handleSubscribe), for: .touchUpInside)
        restoreButton.addTarget(self, action: #selector(handleRestore), for: .touchUpInside)
    }
    
    
    // MARK: - Selectors
    
    @objc private func handleCloseView() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleSubscribe() {
        // RevenueCat
    }
    
    @objc private func handleRestore() {
        
    }
}
