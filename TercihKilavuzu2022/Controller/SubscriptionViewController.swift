//
//  SubscriptionController.swift
//  TercihKilavuzu2022
//
//  Created by İsmail on 13.10.2021.
//

import UIKit

class SubscriptionViewController: UIViewController {
    
    // MARK: - Properties
    
    var fromTabBar = false
    
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
        descriptionView.anchor(top: headerView.bottomAnchor, left: view.leftAnchor, bottom: termsOfServiceView.topAnchor, right: view.rightAnchor, paddingTop: 50)
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
        
        view.isUserInteractionEnabled = true
        
        if !fromTabBar {
            setUpCloseButton()
        }
        setUpButtons()
    }
    
    private func setUpCloseButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(handleCloseView))
    }
    
    private func setUpButtons() {
        print("DEBUG: setUpButtons is triggered")
        subscribeButton.addTarget(self, action: #selector(handleSubscribe), for: .touchUpInside)
        restoreButton.addTarget(self, action: #selector(handleRestore), for: .touchUpInside)
    }
    
    
    // MARK: - Selectors
    
    @objc private func handleCloseView() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleSubscribe() {
        print("DEBUG: handleSubscribe is triggered")
        IAPService.shared.fetchPackages { package in
            guard let package = package else { return }
            
            IAPService.shared.subscribe(package: package) {[weak self] success in
                print("DEBUG: subscribed -> \(success)")
                DispatchQueue.main.async {
                    if success {
                        self?.dismiss(animated: true, completion: nil)
                    }
                    else {
                        let alert = UIAlertController(title: "Satın alma hatası", message: "Premium üyelik satın alımı sırasında hata oluştu!", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Geri Dön", style: .cancel, handler: nil))
                        self?.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    @objc private func handleRestore() {
        print("DEBUG: handleRestore is triggered")
        IAPService.shared.restore {[weak self] success in
            print("DEBUG: restored -> \(success)")
            DispatchQueue.main.async {
                if success {
                    self?.dismiss(animated: true, completion: nil)
                }
                else {
                    let alert = UIAlertController(title: "Premium kontrolü hatası", message: "Önceki Premium üyeliğinizi geri getiremedik!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Geri Dön", style: .cancel, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}
