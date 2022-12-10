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
    
    var currentIndex: Int = 0
    
    var rootViewState = RootViewState.LogHome
    
    private let viewModel: LogTicketViewModel
    
    var imageUrl: [String] = [] {
        didSet {
            setCollectionView()
            setPageControl()
        }
    }
    
    lazy var blurEffectView: UIVisualEffectView = {
        let blurEffectView = UIVisualEffectView(
            effect: UIBlurEffect(
                style: UIBlurEffect.Style.systemUltraThinMaterialDark
            )
        )
        blurEffectView.clipsToBounds = true
        blurEffectView.layer.cornerRadius = 15
        return blurEffectView
    }()
    
    var courseNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.gmarksans(weight: .bold, size: ._15)
        return label
    }()
    
    lazy var editbutton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.designSystem(.mainYellow), for: .normal)
        button.titleLabel?.font = .designSystem(weight: .bold, size: ._11)
        button.layer.borderColor = .designSystem(.mainYellow)
        
        button.backgroundColor = .clear
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.setTitle("수정", for: .normal)
        return button
    }()
    
    lazy var flopButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "refresh"), for: .normal)
        return button
    }()
    
    private let dismissButton: UIButton = {
        let button = UIButton()
        let configure = UIImage.SymbolConfiguration(pointSize: 22, weight: .bold, scale: .default)
        button.setImage(UIImage(systemName: "xmark", withConfiguration: configure), for: .normal)
        button.tintColor = .designSystem(.white)
        return button
    }()
    
    lazy var bodyTextView: UITextView = {
        let textView = UITextView()
        textView.textAlignment = .left
        textView.backgroundColor = .clear
        textView.showsVerticalScrollIndicator = false
        textView.isEditable = false
        return textView
    }()
    
    private let emptyImageView = EmptyImageView()
    
    private let dateTitleLabel = LogTicketLabel(title: "Date", color: .white)
    private let numberTitleLabel = LogTicketLabel(title: "No.", color: .white)
    private let fromTitleLabel = LogTicketLabel(title: "From", color: .white)
    
    var dateLabel = LogTicketLabel(color: .designSystem(Palette.grayC5C5C5) ?? .white)
    var numberLabel = LogTicketLabel(color: .designSystem(Palette.grayC5C5C5) ?? .white)
    var fromLabel = LogTicketLabel(color: .designSystem(Palette.grayC5C5C5) ?? .white)
    
    private let pageControl = UIPageControl()
    
    private let flowLayout: UICollectionViewFlowLayout = {
        let width = DeviceInfo.screenWidth * 0.8974358974
        let height = DeviceInfo.screenHeight * 0.3471563981
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: width, height: height)
        return layout
    }()
    
    private lazy var imageCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.register(LogImageCollectionViewCell.self, forCellWithReuseIdentifier: LogImageCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    // MARK: Initializer
    init(viewModel: LogTicketViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        self.addSubviews(
            courseNameLabel,
            imageCollectionView,
            dateTitleLabel,
            numberTitleLabel,
            fromTitleLabel,
            dateLabel,
            numberLabel,
            fromLabel,
            pageControl,
            bodyTextView,
            // editbutton,
            flopButton,
            dismissButton
        )
        setLayouts()
        setButtonTarget()
        
        self.addSubview(blurEffectView)
        self.sendSubviewToBack(blurEffectView)
        
        blurEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        drawTicket()
    }
}

// MARK: CollectionViewDelegate
extension LogTicketView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrl.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LogImageCollectionViewCell.identifier, for: indexPath) as? LogImageCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(imageUrl: imageUrl[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.tapDismissButton()
        viewModel.presentImageFullScreenViewController(
            imageUrl: imageUrl,
            rootViewState: rootViewState,
            currentImageIndex: indexPath.row
        )
    }
}

// MARK: UIScrollViewDelegate
extension LogTicketView: UIScrollViewDelegate {
    
    private func setCollectionView() {
        switch imageUrl.isEmpty {
        case true:
            addSubview(emptyImageView)
            imageCollectionView.isHidden = true

            emptyImageView.snp.makeConstraints { make in
                make.width.equalToSuperview()
                make.height.equalTo(DeviceInfo.screenHeight * 0.3471563981)
                make.centerX.equalToSuperview()
                make.top.equalToSuperview()
            }
        case false:
            imageCollectionView.isHidden = false
        }
    }
    
    private func setPageControlSelectedPage(currentPage: Int) {
        pageControl.currentPage = currentPage
    }
    
    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        let layout = self.imageCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        
        currentIndex = Int(round(index))
        
        offset = CGPoint(x: CGFloat(currentIndex) * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
        
        setPageControlSelectedPage(currentPage: currentIndex)
    }
    
    // MARK: PageControl 설정
    private func setPageControl() {
        
        pageControl.currentPage = 0
        pageControl.numberOfPages = imageUrl.count
        
        pageControl.pageIndicatorTintColor = UIColor.designSystem(.grayC5C5C5)
        pageControl.currentPageIndicatorTintColor = UIColor.designSystem(Palette.white)
        
        pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(imageCollectionView.snp.bottom)
            make.centerX.equalToSuperview()
        }
    }
}

extension LogTicketView {
    func setTextViewAttributedString() {
        guard let text = bodyTextView.text else { return }
        
        let attributedString = NSMutableAttributedString(
            string: text,
            attributes: [
                .font: UIFont.gmarksans(weight: .light, size: ._13),
                .foregroundColor: UIColor.white
            ]
        )
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineSpacing = 4
        attributedString.addAttribute(
            NSAttributedString.Key.paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: attributedString.length)
        )
        bodyTextView.attributedText = attributedString
    }
    
    // Snapkit을 사용해 Component의 Layout을 배치합니다.
    private func setLayouts() {
        imageCollectionView.snp.makeConstraints { make in
            make.width.equalTo(DeviceInfo.screenWidth * 0.8974358974)
            make.height.equalTo(DeviceInfo.screenHeight * 0.3471563981)
            make.top.centerX.equalToSuperview()
        }
        
        courseNameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(DeviceInfo.screenWidth * 31 / 390)
            make.top.equalTo(imageCollectionView.snp.bottom).offset(DeviceInfo.screenHeight * 0.02369668246)
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
            make.top.equalTo(dateTitleLabel.snp.bottom).offset(5)
        }
        
        numberLabel.snp.makeConstraints { make in
            make.left.equalTo(numberTitleLabel.snp.left)
            make.top.equalTo(numberTitleLabel.snp.bottom).offset(5)
        }
        
        fromLabel.snp.makeConstraints { make in
            make.right.equalTo(fromTitleLabel.snp.right)
            make.top.equalTo(fromTitleLabel.snp.bottom).offset(5)
        }
        
        bodyTextView.snp.makeConstraints { make in
            make.top.equalTo(DeviceInfo.screenHeight * 0.5639810426)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8974358974)
            make.bottom.equalToSuperview().inset(DeviceInfo.screenHeight * 0.05628095212)
        }
        
        /*
        editbutton.snp.makeConstraints { make in
            make.width.equalTo(35)
            make.height.equalTo(20)
            make.right.equalTo(fromLabel.snp.right)
            make.centerY.equalTo(courseNameLabel.snp.centerY)
        }
         */
        
        flopButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.right.equalToSuperview().offset(-DeviceInfo.screenWidth * 0.05128205128)
            make.bottom.equalToSuperview().offset(-DeviceInfo.screenHeight * 0.02369668246)
        }
        
        dismissButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(DeviceInfo.screenWidth * 20 / 390)
            make.top.equalToSuperview().inset(DeviceInfo.screenHeight * 20 / 844)
            make.width.equalTo(DeviceInfo.screenWidth * 22 / 390)
            make.height.equalTo(DeviceInfo.screenHeight * 24 / 844)
        }
    }
    
    // MARK: Ticket Drawing
    private func drawTicket() {
        layer.cornerRadius = 18
        switch rootViewState {
        case .LogHome:
            backgroundColor = .designSystem(.pinkEB97D9)?.withAlphaComponent(0.75)
        case .LogMap:
            backgroundColor = .designSystem(.black)?.withAlphaComponent(0.75)
        }
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
    
    private func setButtonTarget() {
        // editbutton.addTarget(self, action: #selector(tapEditButton), for: .touchUpInside)
        dismissButton.addTarget(self, action: #selector(tapDismissButton), for: .touchUpInside)
    }
    
    @objc
    func tapEditButton() {
        self.viewModel.tapDismissButton()
        self.viewModel.presentEditReview()
    }
    
    @objc
    func tapDismissButton() {
        viewModel.tapDismissButton()
    }
}
