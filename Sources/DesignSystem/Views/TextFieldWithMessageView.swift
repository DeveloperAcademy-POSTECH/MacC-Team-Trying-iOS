//
//  TextFieldWithMessageView.swift
//  MatStarTests
//
//  Created by Jaeyong Lee on 2022/10/15.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

import PinLayout
import SnapKit

protocol TextFieldWithMessageViewComponentDelegate: AnyObject {
    /// 텍스트가 입력되는 실시간 함수
    /// - Parameter text: 텍스트
    func textFieldDidChange(_ text: String)
}

/*
    사용방법
```
    let view: TextFieldWithMessageViewComponent = TextFieldWithMessageView()
    view.delegate = self
    // TextFieldWithMessageViewComponentDelegate 채택
    view.snp.makeConstraints { make in
        make.top.left.right.equalToSuperView()
    }
```
*/
/// 높이는 68로 고정되어 있습니다.
/// 위, 왼쪽, 오른쪽을 잡아주세요.
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
        case invitationCode
    }

    private var textType: TextType
    weak var delegate: TextFieldWithMessageViewComponentDelegate?

    convenience init(textType: TextType) {
        self.init(frame: .zero)
        self.textType = textType
        self.textField.placeholder = textType.placeholder
        switch textType {
        case .email:
            textField.keyboardType = .emailAddress
        case .password:
            textField.isSecureTextEntry = true
        default:
            break
        }
    }

    override init(frame: CGRect) {
        self.textType = .noText
        super.init(frame: frame)

        setUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var textField = UITextField()
    lazy var stateLabel = UILabel()
}

// MARK: - TextFieldWithMessageViewComponent
extension TextFieldWithMessageView: TextFieldWithMessageViewComponent {

    func updateText(_ text: String) {
        textField.text = text
    }

    func updateState(_ state: TextFieldState) {
        stateLabel.isHidden = state == .good
        stateLabel.textColor = state.textColor
        stateLabel.text = state.message
        textField.layer.borderColor = state.borderColor?.cgColor
        textField.layer.borderWidth = 1

    }

    @objc
    func textFieldDidchange(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        delegate?.textFieldDidChange(text)
    }

    func textFieldBecomeFirstResponder() {
        textField.becomeFirstResponder()
    }

    func textFieldResignFirstResponder() {
        textField.resignFirstResponder()
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
        stateLabel.textColor = normalColor
        stateLabel.font = .designSystem(weight: .regular, size: ._11)
        textField.addTarget(self, action: #selector(textFieldDidchange), for: .editingChanged)
        textField.backgroundColor = .designSystem(.white)?.withAlphaComponent(0.2)
        textField.attributedPlaceholder = NSAttributedString(
            string: textField.placeholder ?? "",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.designSystem(.grayC5C5C5) ?? .white,
                NSAttributedString.Key.font: UIFont.designSystem(weight: .regular, size: ._15)
            ]
        )
        textField.clearButtonMode = .whileEditing
        textField.textColor = .white
        textField.leftView = UIView(frame: .init(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.layer.cornerRadius = 15
        textField.layer.masksToBounds = true
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.returnKeyType = .done
    }

    private func addSubviews() {
        addSubview(textField)
        addSubview(stateLabel)
    }

    private func setLayout() {
        textField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.leading.trailing.equalToSuperview()
        }
        stateLabel.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(7)
            make.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(15)
        }
        self.snp.makeConstraints { make in
            make.height.equalTo(68)
        }
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
        case .invitationCode:
            return "초대코드를 입력해 주세요."
        }
    }
}
