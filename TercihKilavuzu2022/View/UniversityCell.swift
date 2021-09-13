//
//  UniversityCell.swift
//  TercihKilavuzu2022
//
//  Created by İsmail on 11.09.2021.
//

import UIKit

class UniversityCell: UITableViewCell {

    // MARK: - Properties
    
    var university: University? {
        didSet {
            configure()
        }
    }
    
    let universityNameLabel: UILabel = {
        var label = UILabel()
        label.text = "Test Universitesi (Ankara)"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    let departmentLabel: UILabel = {
        var label = UILabel()
        label.text = "Test Bölümü (İngilizce)"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    lazy var minScoreLabel: UILabel = createLowerLabels(name: "Taban Puanı")
    
    lazy var minScoreValue: UILabel = createLowerLabels(name: "00000")
    
    lazy var placementLabel: UILabel = createLowerLabels(name: "Sıralaması")
    
    lazy var placementValue: UILabel = createLowerLabels(name: "00000")
    
    lazy var quotaLabel: UILabel = createLowerLabels(name: "Kontenjanı")
    
    lazy var quotaValue: UILabel = createLowerLabels(name: "00")
    
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureCellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configureCellUI() {        
        addSubview(universityNameLabel)
        universityNameLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 16, paddingLeft: 12)
        
        addSubview(departmentLabel)
        departmentLabel.anchor(top: universityNameLabel.bottomAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 12)
        
        let minScoreStack = createLowerStackViews(subviews: [minScoreLabel, minScoreValue])
        
        let placementStack = createLowerStackViews(subviews: [placementLabel, placementValue])
        
        let quotaStack = createLowerStackViews(subviews: [quotaLabel, quotaValue])
        
        let bottomStack = UIStackView(arrangedSubviews: [minScoreStack, placementStack, quotaStack])
        bottomStack.axis = .horizontal
        bottomStack.distribution = .equalSpacing
        
        addSubview(bottomStack)
        bottomStack.anchor(top: departmentLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
    }
    
    private func createLowerLabels(name: String) -> UILabel {
        let label = UILabel()
        label.text = name
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        return label
    }
    
    private func createLowerStackViews(subviews: [UIView]) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: subviews)
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .center
        stack.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return stack
    }
    
    private func configure() {
        guard let university = university else { return }
        let viewModel = UniversityViewModel(university: university)
        
//        universityNameLabel.text = university.name
        universityNameLabel.attributedText = viewModel.universityNameLabel
//        departmentLabel.text = university.department
        departmentLabel.attributedText = viewModel.departmentLabel
        minScoreValue.text = university.minScore
        placementValue.text = university.placement
        quotaValue.text = university.quota
    }
}
