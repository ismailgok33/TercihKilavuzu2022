//
//  CountdownView.swift
//  TercihKilavuzu2022
//
//  Created by İsmail on 26.09.2021.
//

import UIKit

class TYTCountdownGraphView: UIView {
    
    // MARK: - Properties
    
    var shapeLayer: CAShapeLayer!
    var pulsatingLayer: CAShapeLayer!
    
    private var remainingDays: Int
    
    var percentageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    // MARK: - Lifecycle

    override init(frame: CGRect) {
        self.remainingDays = 250
        
        super.init(frame: frame)
        
        let attributedString = NSMutableAttributedString(attributedString: NSAttributedString(string: "TYT", attributes: [.font: UIFont.boldSystemFont(ofSize: 32)]))
        attributedString.append(NSAttributedString(string: "(\(remainingDays) gün)", attributes: [.font: UIFont.systemFont(ofSize: 14)]))
        percentageLabel.attributedText = attributedString
        
        backgroundColor = UIColor.backgroundColor
        
        setupCircleLayers()
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
        setupPercentageLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - Helpers
    
    private func createCircleShapeLayer(strokeColor: UIColor, fillColor: UIColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 90, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        layer.path = circularPath.cgPath
        layer.strokeColor = strokeColor.cgColor
        layer.lineWidth = 16
        layer.fillColor = fillColor.cgColor
        layer.lineCap = CAShapeLayerLineCap.round
        layer.position = center
        return layer
    }
    
    private func setupPercentageLabel() {
        addSubview(percentageLabel)
        percentageLabel.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        percentageLabel.center = center
    }
    
    private func setupCircleLayers() {
        pulsatingLayer = createCircleShapeLayer(strokeColor: .clear, fillColor: UIColor.pulsatingFillColor)
        layer.addSublayer(pulsatingLayer)
        // animatePulsatingLayer()
        
        let trackLayer = createCircleShapeLayer(strokeColor: .trackStrokeColor, fillColor: .backgroundColor)
        layer.addSublayer(trackLayer)
        
        shapeLayer = createCircleShapeLayer(strokeColor: .outlineStrokeColor, fillColor: .clear)
        
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        shapeLayer.strokeEnd = 0
        layer.addSublayer(shapeLayer)
    }
    
    private func animatePulsatingLayer() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        
        animation.toValue = 1.25
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        
        pulsatingLayer.add(animation, forKey: "pulsing")
    }
    
    func animateCircle() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.toValue = CGFloat(365 - remainingDays) / CGFloat(365)
        
        basicAnimation.duration = 2
        
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
    }
    
    // MARK: - Selectors
    
    @objc private func handleEnterForeground() {
        animatePulsatingLayer()
    }
    
    @objc private func handleTap() {
        animateCircle()
    }
}
