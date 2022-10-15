//
//  TextFieldWithMessageView.swift
//  MatStarTests
//
//  Created by Jaeyong Lee on 2022/10/15.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

import PinLayout

protocol TextFieldWithMessageViewComponentDelegate: AnyObject {
    /// 텍스트가 입력되는 실시간 함수
    /// - Parameter text: 텍스트
    func textFieldDidChange(_ text: String)
}

final class TextFieldWithMessageView: UIView {
    private let failColor: UIColor? = .red
    private let successColor: UIColor? = .green
    private let normalColor: UIColor? = .clear

    enum TextType {
        case nickname
        case password
        case email
        case certificationNumber
        case noText
    }

    private var textType: TextType
    weak var delegate: TextFieldWithMessageViewComponentDelegate?

    convenience init(textType: TextType) {
        self.init(frame: .zero)
        self.textType = textType
        self.textField.placeholder = textType.placeholder
    }

    override init(frame: CGRect) {
        self.textType = .noText
        super.init(frame: frame)

        setUI()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var textField = UITextField()
    lazy var errorLabel = UILabel()
}

// MARK: - TextFieldErrorable
extension TextFieldWithMessageView: TextFieldWithMessageViewComponent {

    func showError(type errorType: IntroErrorType) {
        errorLabel.isHidden = errorType == .noError
        errorLabel.textColor = errorType.color
        errorLabel.text = errorType.message
        textField.layer.borderColor = errorType.color?.cgColor
        textField.layer.borderWidth = 1
    }

    @objc
    func textFieldDidchange(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        delegate?.textFieldDidChange(text)
    }
}

// MARK: - UI
extension TextFieldWithMessageView {
    private func setUI() {
        addSubviews()
        setAttribute()
        setLayout()
    }

    private func setAttribute() {
        errorLabel.textColor = normalColor
        errorLabel.font = .boldSystemFont(ofSize: 12)
        textField.addTarget(self, action: #selector(textFieldDidchange), for: .editingChanged)
        textField.backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1)
        textField.textColor = .white
        textField.leftView = UIView()
        textField.leftViewMode = .always
        textField.leftView?.pin.width(15)
        textField.layer.cornerRadius = 15
        textField.layer.masksToBounds = true

        self.setClearButton()
    }

    private func setClearButton() {
        let clearButtonWrappedView = UIView(frame: CGRect(origin: .zero, size: .init(width: 30, height: 20)))
        let clearButton = UIButton(type: .system)
        let image = UIImage(systemName: "xmark.circle.fill")?.withTintColor(.black)
        clearButton.setImage(image, for: .normal)
        clearButton.addTarget(self, action: #selector(clearButtonDidTap), for: .touchUpInside)
        clearButton.tintColor = .black
        clearButtonWrappedView.addSubview(clearButton)
        clearButton.pin.top().bottom().left().width(20)
        textField.rightView = clearButtonWrappedView
        textField.clearButtonMode = .never
        textField.rightViewMode = .whileEditing
    }

    @objc
    func clearButtonDidTap() {
        self.textField.text?.removeAll()
    }

    private func addSubviews() {
        addSubview(textField)
        addSubview(errorLabel)
    }

    private func setLayout() {
        textField.pin.top().left().right().height(50)
        errorLabel.pin.below(of: textField).left().right().margin(3, 8, 8).height(15)
    }
}

// MARK: - Constants
extension TextFieldWithMessageView.TextType {

    var placeholder: String? {
        switch self {
        case .nickname:
            return "닉네임을 입력해 주세요."
        case .password:
            return "비밀번호를 입력해 주세요."
        case .email:
            return "이메일을 입력해 주세요."
        case .certificationNumber:
            return "인증번호를 입력해 주세요."
        case .noText:
            return ""
        }
    }
}
