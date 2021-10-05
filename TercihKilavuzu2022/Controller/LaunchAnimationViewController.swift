//
//  LaunchAnimationViewController.swift
//  TercihKilavuzu2022
//
//  Created by İsmail on 6.10.2021.
//

import UIKit

class LaunchAnimationViewController: UIViewController {
    
    // MARK: - Properties
    
    let imageView: UIImageView = {
        let iv = UIImageView(frame: CGRect(x: 0, y: 0, width: 428, height: 428))
        iv.image = UIImage(named: "tercih_kilavuzu_image")
        return iv
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        view.backgroundColor = #colorLiteral(red: 0.793368876, green: 0.9500890374, blue: 0.921333313, alpha: 1)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.center = view.center
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.animate()
        }
    }
    
    // MARK: - Helpers
    
    func animate() {
        UIView.animate(withDuration: 1) {
            let size = self.view.frame.size.width * 3
            let diffX = size - self.view.frame.size.width
            let diffY = self.view.frame.size.height - size
            
            self.imageView.frame = CGRect(x: -(diffX / 2), y: diffY / 2, width: size, height: size)
            
        }
        
        UIView.animate(withDuration: 1.5) {
            self.imageView.alpha = 0
//            self.view.backgroundColor = UIColor(white: 1, alpha: 0.5)
        } completion: { done in
            if done {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    let vc = MainTabController()
                    vc.modalPresentationStyle = .fullScreen
                    vc.modalTransitionStyle = .crossDissolve
                    self.present(vc, animated: true)
                }
            }
        }

    }
}
