//
//  AYTCountdownGraphView.swift
//  TercihKilavuzu2022
//
//  Created by İsmail on 26.09.2021.
//

import UIKit

class AYTCountdownGraphView: UIView {
    
    // MARK: - Properties
    
    private let timeLeftShapeLayer = CAShapeLayer()
    private let bgShapeLayer = CAShapeLayer()
    private var timeLeft: TimeInterval = 250
    private var endTime: TimeInterval = 365
    private var timeLabel =  UILabel()
    private var timer = Timer()
    // here you create your basic animation object to animate the strokeEnd
    private let strokeIt = CABasicAnimation(keyPath: "strokeEnd")
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        configureUI()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        backgroundColor = UIColor(white: 0.94, alpha: 1.0)
        drawBgShape()
        drawTimeLeftShape()
        addTimeLabel()
        // here you define the fromValue, toValue and duration of your animation
        strokeIt.fromValue = Float(365-250)/Float(365)
        strokeIt.toValue = 1
//        strokeIt.duration = timeLeft
        strokeIt.duration = (365-250)*60
        // add the animation to your timeLeftShapeLayer
        timeLeftShapeLayer.add(strokeIt, forKey: nil)
        // define the future end time by adding the timeLeft to now Date()
        //endTime = Date().addingTimeInterval(timeLeft)
        //timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    func drawBgShape() {
        bgShapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: frame.midX , y: frame.midY), radius:
            100, startAngle: -90.degreesToRadians, endAngle: 270.degreesToRadians, clockwise: true).cgPath
        bgShapeLayer.strokeColor = UIColor.white.cgColor
        bgShapeLayer.fillColor = UIColor.clear.cgColor
        bgShapeLayer.lineWidth = 15
        layer.addSublayer(bgShapeLayer)
    }
    func drawTimeLeftShape() {
        timeLeftShapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: frame.midX , y: frame.midY), radius:
            100, startAngle: -90.degreesToRadians, endAngle: 270.degreesToRadians, clockwise: true).cgPath
        timeLeftShapeLayer.strokeColor = UIColor.myCustomBlue.cgColor
        timeLeftShapeLayer.fillColor = UIColor.clear.cgColor
        timeLeftShapeLayer.lineWidth = 15
        layer.addSublayer(timeLeftShapeLayer)
    }
    
    func addTimeLabel() {
        timeLabel = UILabel(frame: CGRect(x: frame.midX-50 ,y: frame.midY-25, width: 100, height: 50))
        timeLabel.textAlignment = .center
        timeLabel.text = timeLeft.time
//        timeLabel.text = endTime.time
        addSubview(timeLabel)
    }
    
    // MARK: - Selectors
    
    @objc func updateTime() {
        if timeLeft > 0 {
            timeLeft -= 1
            timeLabel.text = timeLeft.time
        } else {
            timeLabel.text = "00:00"
            timer.invalidate()
        }
    }
}
