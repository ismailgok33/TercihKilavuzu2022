//
//  AboutController.swift
//  TercihKilavuzu2022
//
//  Created by İsmail on 29.09.2021.
//

import UIKit
import SafariServices
import MessageUI

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
    
    private lazy var feedbackButton: UIButton = {
        let button = UIButton()
        button.setTitle("Geri Bildirim Gönder", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleFeedBack), for: .touchUpInside)
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
                         paddingTop: 30, paddingLeft: 20, paddingRight: 20)
        
        view.addSubview(webSitelink)
        webSitelink.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor,
                           paddingBottom: 20)
        webSitelink.centerX(inView: view)
        
        view.addSubview(feedbackButton)
        feedbackButton.anchor(left: view.leftAnchor, bottom: webSitelink.topAnchor, right: view.rightAnchor, paddingLeft: 40,paddingBottom: 10, paddingRight: 40, height: 40)
    }
    
    func openMailApp() {
        let mailVC = MFMailComposeViewController()
        mailVC.delegate = self
        mailVC.setSubject("Geri bildirim")
        mailVC.setToRecipients(["tercihkilavuzuapp@gmail.com"])
        mailVC.setMessageBody("Test", isHTML: false)
        present(mailVC, animated: true)
    }
    
    func openWebSite() {
        guard let url = URL(string: "http://www.google.com") else { return }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true, completion: nil)
    }
    
    // MARK: - Selectors
    
    @objc private func goToAppWebSite() {
        openWebSite()
    }
    
    @objc private func handleFeedBack() {
        if MFMailComposeViewController.canSendMail() {
            openMailApp()
        }
        else {
            openWebSite()
        }
        
    }
}

extension AboutController: MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
