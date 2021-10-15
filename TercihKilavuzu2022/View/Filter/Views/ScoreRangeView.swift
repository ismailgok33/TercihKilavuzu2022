//
//  ScoreRangeView.swift
//  TercihKilavuzu2022
//
//  Created by İsmail on 21.09.2021.
//

import UIKit

class ScoreRangeView: UIView {
    
    // MARK: - Properties
    
    private let viewTitle: UILabel = {
        let label = UILabel()
        label.text = "Puan Aralığı"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
     let minScoreField: UITextField = {
        let tf = UITextField()
        
        let spacer = UIView()
        spacer.setDimensions(width: 12, height: 40)
        tf.leftView = spacer
        tf.leftViewMode = .always
        
        tf.textColor = .white
        tf.tintColor = .white
        tf.borderStyle = .none
        tf.backgroundColor = UIColor(white: 1, alpha: 0.2)
        tf.heightAnchor.constraint(equalToConstant: 40).isActive = true
        tf.layer.cornerRadius = 5
        tf.keyboardType = UIKeyboardType.numberPad
        tf.attributedPlaceholder = NSAttributedString(string: "Minimum", attributes: [.foregroundColor: UIColor(white: 1, alpha: 0.7)])
        return tf
    }()
    
     let maxScoreField: UITextField = {
        let tf = UITextField()
        
        let spacer = UIView()
        spacer.setDimensions(width: 12, height: 40)
        tf.leftView = spacer
        tf.leftViewMode = .always
        
        tf.textColor = .white
        tf.tintColor = .white
        tf.borderStyle = .none
        tf.backgroundColor = UIColor(white: 1, alpha: 0.2)
        tf.heightAnchor.constraint(equalToConstant: 40).isActive = true
        tf.layer.cornerRadius = 5
        tf.keyboardType = UIKeyboardType.numberPad
        tf.attributedPlaceholder = NSAttributedString(string: "Maksimum", attributes: [.foregroundColor: UIColor(white: 1, alpha: 0.7)])
        return tf
    }()
    
    // MARK: - Lifecycle
    
    init(minScore: Double?, maxScore: Double?) {
        super.init(frame: .zero)
        
        if let safeMinScore = minScore {
            minScoreField.text = "\(safeMinScore)"
        }
        
        if let safeMaxScore = maxScore {
            maxScoreField.text = "\(safeMaxScore)"
        }
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configureUI() {
//        backgroundColor = .filterBackgroundColor
        backgroundColor = .clear
        
        addSubview(viewTitle)
        viewTitle.anchor(top: topAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 12)
        
        let stack = UIStackView(arrangedSubviews: [minScoreField, maxScoreField])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 20
        addSubview(stack)
        stack.anchor(top:viewTitle.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 12, paddingRight: 12)
    }
}

