//
//  LogTicketView.swift
//  ComeIt
//
//  Created by YeongJin Jeong on 2022/11/07.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit
import SnapKit

class LogTicketView: UIView {
    
    var courseNameLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.gmarksans(weight: .bold, size: ._15)
        return label
    }()
    
    var imageUrl: [String] = [] {
        didSet {
            setScrollView()
            setPageControl()
        }
    }
    
    private let dateTitleLabel = LogTicketLabel(title: "Date", color: .white)
    private let numberTitleLabel = LogTicketLabel(title: "No.", color: .white)
    private let fromTitleLabel = LogTicketLabel(title: "From", color: .white)
    var dateLabel = LogTicketLabel(color: .designSystem(Palette.grayC5C5C5) ?? .white)
    var numberLabel = LogTicketLabel(color: .designSystem(Palette.grayC5C5C5) ?? .white)
    var fromLabel = LogTicketLabel(color: .designSystem(Palette.grayC5C5C5) ?? .white)
    private let pageControl = UIPageControl()
    
    private var ImageScrollView: UIScrollView = {
        var scrollView = UIScrollView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: DeviceInfo.screenWidth * 0.8974358974,
                height: DeviceInfo.screenHeight * 0.3471563981
            )
        )
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.designSystem(Palette.glassPink)
        layer.cornerRadius = 18
        print(imageUrl.count)
        
        self.addSubviews(courseNameLabel, ImageScrollView, dateTitleLabel, numberTitleLabel, fromTitleLabel, dateLabel, numberLabel, fromLabel, pageControl)
        
        ImageScrollView.snp.makeConstraints { make in
            make.width.equalTo(DeviceInfo.screenWidth * 0.8974358974)
            make.height.equalTo(DeviceInfo.screenHeight * 0.3471563981)
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        courseNameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(DeviceInfo.screenWidth * 0.05128205128)
            make.top.equalTo(ImageScrollView.snp.bottom).offset(DeviceInfo.screenHeight * 0.02369668246)
        }
        dateTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(courseNameLabel.snp.left)
            make.top.equalTo(courseNameLabel.snp.bottom).offset(DeviceInfo.screenHeight * 0.02369668246)
        }
        numberTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(dateTitleLabel.snp.top)
        }
        fromTitleLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-DeviceInfo.screenWidth * 0.05128205128)
            make.top.equalTo(numberTitleLabel.snp.top)
        }
        dateLabel.snp.makeConstraints { make in
            make.left.equalTo(dateTitleLabel.snp.left)
            make.top.equalTo(dateTitleLabel.snp.bottom)
        }
        numberLabel.snp.makeConstraints { make in
            make.left.equalTo(numberTitleLabel.snp.left)
            make.top.equalTo(numberTitleLabel.snp.bottom)
        }
        fromLabel.snp.makeConstraints { make in
            make.right.equalTo(fromTitleLabel.snp.right)
            make.top.equalTo(fromTitleLabel.snp.bottom)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        drawTicket()
    }
}

extension LogTicketView: UIScrollViewDelegate {
    
    private func setScrollView() {
        for index in 0..<imageUrl.count {
            let imageView = UIImageView()
            let xPos = ImageScrollView.frame.width * CGFloat(index)
            imageView.frame = CGRect(x: xPos, y: 0, width: ImageScrollView.bounds.width, height: ImageScrollView.bounds.height)
            imageView.image = UIImage(named: imageUrl[index])
            ImageScrollView.addSubview(imageView)
            ImageScrollView.contentSize.width = imageView.frame.width * CGFloat(index + 1)
            ImageScrollView.delegate = self
        }
    }
    
    private func setPageControlSelectedPage(currentPage: Int) {
        pageControl.currentPage = currentPage
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let value = scrollView.contentOffset.x / scrollView.frame.size.width
        setPageControlSelectedPage(currentPage: Int(round(value)))
    }
    
    private func setPageControl() {
        pageControl.currentPage = 0
        pageControl.numberOfPages = imageUrl.count
        pageControl.pageIndicatorTintColor = UIColor.designSystem(Palette.grayC5C5C5)
        pageControl.currentPageIndicatorTintColor = UIColor.designSystem(Palette.pinkEB97D9)

        pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(ImageScrollView.snp.bottom)
            make.centerX.equalToSuperview()
        }
    }
}

extension LogTicketView {
    func configure(with model: TestModel) {
        dateTitleLabel.text = model.date
    }
    
    private func drawTicket() {
        let radious = DeviceInfo.screenWidth * 0.1282051282 / 2
        
        let ticketShapeLayer = CAShapeLayer()
        ticketShapeLayer.frame = self.bounds
        ticketShapeLayer.fillColor = UIColor.designSystem(.glassPink)?.cgColor
        ticketShapeLayer.opacity = 1
        
        let ticketShapePath = UIBezierPath(roundedRect: ticketShapeLayer.bounds, cornerRadius: radious)
        let bottomRightArcPath = UIBezierPath(
            arcCenter: CGPoint(
                x: ticketShapeLayer.frame.width,
                y: DeviceInfo.screenHeight * 0.5106635071
            ),
            radius: radious,
            startAngle: CGFloat( Double.pi / 2 ),
            endAngle: CGFloat(Double.pi + Double.pi / 2),
            clockwise: true
        )
        bottomRightArcPath.close()
        
        let bottomLeftArcPath = UIBezierPath(
            arcCenter: CGPoint(x: 0, y: DeviceInfo.screenHeight * 0.5106635071),
            radius: radious,
            startAngle: CGFloat(Double.pi / 2),
            endAngle: CGFloat(Double.pi / 2 + Double.pi),
            clockwise: false
        )
        bottomRightArcPath.close()
        
        let lineShapeLayer = CAShapeLayer()
        
        lineShapeLayer.strokeColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0.3).cgColor
        lineShapeLayer.lineWidth = 3
        lineShapeLayer.lineDashPattern = [5, 5]
        
        let path = CGMutablePath()
        path.addLines(
            between: [
                CGPoint(x: 18, y: DeviceInfo.screenHeight * 0.5106635071),
                CGPoint(x: ticketShapeLayer.bounds.size.width - 18, y: DeviceInfo.screenHeight * 0.5106635071)
            ]
        )
        
        lineShapeLayer.path = path
        ticketShapePath.append(bottomLeftArcPath)
        ticketShapePath.append(bottomRightArcPath.reversing())
        ticketShapeLayer.path = ticketShapePath.cgPath
        layer.addSublayer(lineShapeLayer)
        layer.shadowColor = UIColor.systemGray.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 10
        layer.shadowOffset = .zero
        layer.mask = ticketShapeLayer
    }
}
