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
    
    var rootViewState = RootViewState.LogHome {
        didSet {
            setBlur()
        }
    }
    
    var imageUrl: [String] = [] {
        didSet {
            setScrollView()
            setPageControl()
        }
    }
    
    var courseNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.gmarksans(weight: .bold, size: ._15)
        return label
    }()
    
    lazy var likebutton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "unlike_image"), for: .normal)
        return button
    }()
    
    lazy var flopButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "refresh"), for: .normal)
        return button
    }()
    
    var bodyTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.designSystem(weight: .regular, size: ._13)
        textView.textAlignment = .left
        textView.backgroundColor = .clear
        textView.showsVerticalScrollIndicator = false
        textView.isEditable = false
        return textView
    }()
    
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
    // MARK: Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubviews(
            courseNameLabel,
            ImageScrollView,
            dateTitleLabel,
            numberTitleLabel,
            fromTitleLabel,
            dateLabel,
            numberLabel,
            fromLabel,
            pageControl,
            bodyTextView,
            likebutton,
            flopButton
        )
        setLayouts()
        
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
            guard let url = URL(string: imageUrl[index]) else { return }
            imageView.load(url: url)
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
    // MARK: PageControl 설정
    private func setPageControl() {
        pageControl.currentPage = 0
        pageControl.numberOfPages = imageUrl.count
        pageControl.pageIndicatorTintColor = UIColor.designSystem(Palette.grayC5C5C5)
        pageControl.currentPageIndicatorTintColor = UIColor.designSystem(Palette.pinkFF0099)
        
        pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(ImageScrollView.snp.bottom)
            make.centerX.equalToSuperview()
        }
    }
}

extension LogTicketView {
    // Snapkit을 사용해 Component의 Layout을 배치합니다.
    private func setLayouts() {
        
        ImageScrollView.snp.makeConstraints { make in
            make.width.equalTo(DeviceInfo.screenWidth * 0.8974358974)
            make.height.equalTo(DeviceInfo.screenHeight * 0.3471563981)
            make.top.centerX.equalToSuperview()
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
        
        bodyTextView.snp.makeConstraints { make in
            make.top.equalTo(DeviceInfo.screenHeight * 0.5639810426)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8974358974)
            make.bottom.equalToSuperview().inset(DeviceInfo.screenHeight * 0.05628095212)
        }
        
        likebutton.snp.makeConstraints { make in
            make.width.equalTo(DeviceInfo.screenWidth * 0.05128205128)
            make.height.equalTo(DeviceInfo.screenHeight * 0.02191943128)
            make.right.equalTo(fromLabel.snp.right)
            make.centerY.equalTo(courseNameLabel.snp.centerY)
        }
        
        flopButton.snp.makeConstraints { make in
            make.width.equalTo(DeviceInfo.screenWidth * 0.06153846154)
            make.height.equalTo(DeviceInfo.screenHeight * 0.02843601896)
            make.right.equalToSuperview().offset(-DeviceInfo.screenWidth * 0.05128205128)
            make.bottom.equalToSuperview().offset(-DeviceInfo.screenHeight * 0.02369668246)
        }
    }
    
    // MARK: Ticket Drawing
    private func drawTicket() {
        layer.cornerRadius = 18
        backgroundColor = .clear
        let radious = DeviceInfo.screenWidth * 0.1282051282 / 2
        let ticketShapeLayer = CAShapeLayer()
        ticketShapeLayer.frame = self.bounds
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
    
    // MARK: Blur Effect 추가
    private func setBlur() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        let outerVisualEffectView = UIVisualEffectView(effect: blurEffect)
        
        switch rootViewState {
        case .LogHome:
            outerVisualEffectView.layer.backgroundColor = UIColor.designSystem(.pinkF09BA1)?.withAlphaComponent(0.5).cgColor
        case .LogMap:
            outerVisualEffectView.layer.backgroundColor = UIColor.designSystem(.black)?.withAlphaComponent(0.75).cgColor
        }
        
        outerVisualEffectView.layer.opacity = 0.5
        outerVisualEffectView.frame = CGRect(x: 0, y: 0, width: DeviceInfo.screenWidth, height: DeviceInfo.screenHeight)
        self.addSubview(outerVisualEffectView)
        self.sendSubviewToBack(outerVisualEffectView)
    }
}
