//
//  EditViewController.swift
//  01_Portfolio
//
//  Created by Raphael Shim on 2023/03/29.
//

import UIKit
import PanModal

class EditViewController: UIViewController {
    @IBOutlet weak var nicknameLabel: UILabel!       // 닉네임 레이블
    @IBOutlet weak var oneLineProfileLabel: UILabel! // 한 줄 프로필 레이블
    @IBOutlet weak var aboutMeLabel: UILabel!        // 자기소개 레이블
    
    @IBOutlet weak var nicknameTextField: UITextField!       // 닉네임 텍스트 필드
    @IBOutlet weak var oneLineProfileTextField: UITextField! // 한 줄 프로필 텍스트 필드
    @IBOutlet weak var aboutMeTextView: UITextView!          // 자기소개 텍스트 뷰
    @IBOutlet weak var textViewPlaceholder: UILabel!         // 자기소개 텍스트 뷰 플레이스홀더
    
    @IBOutlet weak var websiteLinkTextField: UITextField!          // 기본적으로 보여주는 첫 번째 웹사이트 링크 텍스트 필드
    @IBOutlet weak var addSecondWebsiteLinkTextField: UITextField! // 숨겨진 두 번째 웹사이트 링크 텍스트 필드
    @IBOutlet weak var addThirdWebsiteLinkTextField: UITextField!  // 숨겨진 세 번째 웹사이트 링크 텍스트 필드
    
    @IBOutlet weak var nicknameCountLabel: UILabel!       // 닉네임 텍스트 필드 글자 수 카운트 레이블
    @IBOutlet weak var oneLineProfileCountLabel: UILabel! // 한 줄 프로필 텍스트 필드 글자 수 카운트 레이블
    @IBOutlet weak var aboutMeCountLabel: UILabel!        // 자기소개 텍스트 뷰 글자 수 카운트 레이블
    
    @IBOutlet weak var textFieldStackView: UIStackView!       // 웹사이트 링크 3개 모두를 담고 있는 스택 뷰
    @IBOutlet weak var secondTextFieldStackView: UIStackView! // 숨겨진 두 번째 웹사이트 링크 스택 뷰
    @IBOutlet weak var thirdTextFieldStackView: UIStackView!  // 숨겨진 세 번째 웹사이트 링크 스택 뷰
    
    @IBOutlet weak var warningMessageLabel: UILabel! // 웹사이트 링크 3개를 초과해서 생성하려고 하면 보이는 경고 메시지
    
    @IBOutlet weak var scrollView: UIScrollView! // 키보드를 올렸을 때 입력 필드가 가려지지 않도록 스크롤 뷰를 계산하기 위한 아웃렛
    
    // [UITextField]와 [UITextView] 타입의 빈 배열로 초기화
    var textFields: [UITextField] = []
    var textViews: [UITextView] = []
    
    // MainViewController에서 저장된 데이터들을 저장하는 튜플
    // EditViewController가 열릴 때 이전 데이터가 입력 폼에 보여짐
    var data: (
        nickname: String,
        oneLineProfile: String,
        aboutMe: String,
        firstWebsite: String,
        secondWebsite: String,
        thirdWebsite: String
    )?
    
    // 앱 내부에 데이터를 저장
    let defaults = UserDefaults.standard
    
    // 키보드의 높이를 저장하는 변수
    var keyboardHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // textFields 배열에 뷰 컨트롤러 내부에 있는 nicknameTextField, oneLineProfileTextField 객체 할당
        textFields = [nicknameTextField, oneLineProfileTextField]
        // textViews 배열에 뷰 컨트롤러 내부에 있는 aboutMeTextView 객체 할당
        textViews = [aboutMeTextView]
        
        // textFields 배열에 있는 각 UITextField 객체에 대해 setToolbar() 메서드를 호출하여 키보드 위에 툴바 추가
        for textField in textFields {
            textField.inputAccessoryView = setToolbar()
        }
        
        // textViews 배열에 있는 각 UITextView 객체에 대해도 setToolbar() 메서드를 호출하여 키보드 위에 툴바 추가
        for textView in textViews {
            textView.inputAccessoryView = setToolbar()
        }
        
        // 뷰 컨트롤러가 처음 나타날 때, nicknameTextField 객체에 바로 입력을 할 수 있도록 하기 위한 코드
        nicknameTextField.becomeFirstResponder()
        
        // 키보드 이벤트 관련 옵저버 등록
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification, object: nil
        )
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification, object: nil
        )
        
        // 스크롤 뷰의 콘텐츠 크기 지정
        scrollView.contentSize = view.frame.size
        scrollView.keyboardDismissMode = .interactive
        
        // delegate: 특정 객체에 대한 이벤트나 상태 변경을 다른 객체에게 전달하는 데 사용하는 패턴
        // 텍스트 필드와 텍스트 뷰에서 사용자의 입력에 대한 이벤트를 처리할 수 있도록 현재 객체(self)를 delegate로 설정하는 것
        nicknameTextField.delegate = self
        oneLineProfileTextField.delegate = self
        aboutMeTextView.delegate = self
        websiteLinkTextField.delegate = self
        addSecondWebsiteLinkTextField.delegate = self
        addThirdWebsiteLinkTextField.delegate = self
        
        setLabels()     // 특정 레이블(*)에 빨간색 옷을 입히는 코드
        setTextFields() // 적용할 텍스트 필드의 이름, 모서리 둥글기, 테두리 두께, 테두리 색상, 왼쪽과 오른쪽에 여백을 주는 함수
        setTextView()   // 텍스트 뷰의 테두리 두께, 테두리 색상, 모서리 둥글기, 안쪽에 여백을 주는 함수
        
        hideKeyboardWhenTappedAround() // 빈 곳을 터치하면 키보드가 아래로 내려가는 함수
        
        secondTextFieldStackView.isHidden = true // 두 번째 웹사이트 링크 숨겨짐 처리
        thirdTextFieldStackView.isHidden = true  // 세 번째 웹사이트 링크 숨겨짐 처리
        
        savedData() // 텍스트 필드에 정보를 입력하고 완료를 누른 뒤, 다시 수정 화면으로 왔을 때 입력했던 정보들이 그대로 남아있게 하는 함수
        
        // aboutMeTextView에 입력된 텍스트가 있으면 textViewPlaceholder를 숨김 처리
        if !aboutMeTextView.text.isEmpty {
            textViewPlaceholder.isHidden = true
        }
        
        // UserDefaults에서 가져온 값을 각 컴포넌트에 적용
        nicknameTextField.text = defaults.string(forKey: "nickname")
        oneLineProfileTextField.text = defaults.string(forKey: "oneLineProfile")
        aboutMeTextView.text = defaults.string(forKey: "aboutMe")
        websiteLinkTextField.text = defaults.string(forKey: "firstWebsite")
        addSecondWebsiteLinkTextField.text = defaults.string(forKey: "secondWebsite")
        addThirdWebsiteLinkTextField.text = defaults.string(forKey: "thirdWebsite")
        
        updateCountLabels() // 글자 수 업데이트
    }
    
    // MARK: - 뷰가 나타나기 전에 호출되는 함수
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 현재 뷰 컨트롤러를 모달로 호출한 MainViewController를 가져와서 참조
        if let mainVC = presentingViewController as? MainViewController {
            // MainViewController에서 두 번째 웹사이트 링크 뷰가 보이는 상태이면
            if mainVC.secondWebsiteView.isHidden == false {
                // 두 번째 웹사이트 링크 텍스트 필드와 레이블을 보이도록 함
                secondTextFieldStackView.isHidden = false
            }
            // MainViewController에서 세 번째 웹사이트 링크 뷰가 보이는 상태이면
            if mainVC.thirdWebsiteView.isHidden == false {
                // 세 번째 웹사이트 링크 텍스트 필드와 라벨을 보이도록 함
                thirdTextFieldStackView.isHidden = false
            }
        }
        
    }
    
    // MARK: - 뷰 컨트롤러가 화면에서 사라질 때 호출되는 함수
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // nicknameTextField에서 입력한 값을 "nickname"이라는 key 값으로 UserDefaults에 저장
        defaults.set(nicknameTextField.text, forKey: "nickname")
        // oneLineProfileTextField에서 입력한 값을 "oneLineProfile"이라는 key 값으로 UserDefaults에 저장
        defaults.set(oneLineProfileTextField.text, forKey: "oneLineProfile")
        // aboutMeTextView에서 입력한 값을 "aboutMe"라는 key 값으로 UserDefaults에 저장
        defaults.set(aboutMeTextView.text, forKey: "aboutMe")
        // websiteLinkTextField에서 입력한 값을 "firstWebsite"라는 key 값으로 UserDefaults에 저장
        defaults.set(websiteLinkTextField.text, forKey: "firstWebsite")
        // addSecondWebsiteLinkTextField에서 입력한 값을 "secondWebsite"라는 key 값으로 UserDefaults에 저장
        defaults.set(addSecondWebsiteLinkTextField.text, forKey: "secondWebsite")
        // addThirdWebsiteLinkTextField에서 입력한 값을 "thirdWebsite"라는 key 값으로 UserDefaults에 저장
        defaults.set(addThirdWebsiteLinkTextField.text, forKey: "thirdWebsite")
        // UserDefaults에 저장한 값을 디스크에 즉시 기록하도록 함
        defaults.synchronize()
    }
    
    // MARK: - 키보드가 나타날 때 실행되는 함수
    @objc func keyboardWillShow(_ sender: Notification) {
        // 전달받은 Notification에서 유용한 정보를 추출하기 위해 userInfo 속성을 이용
        let userInfo = sender.userInfo!
        // 키보드가 화면에 나타날 때, 화면 상단에서 키보드의 크기를 가져오는 부분
        let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        // 키보드의 높이를 가져와서 keyboardHeight 변수에 저장
        keyboardHeight = keyboardFrame.height
        
        // 스크롤 뷰의 컨텐츠를 키보드가 나타날 때 높이만큼 스크롤 하도록 해주는 부분
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        // 스크롤 뷰의 컨텐츠 인셋을 설정
        scrollView.contentInset = contentInsets
        // 스크롤 뷰의 스크롤 인디케이터의 인셋을 설정
        scrollView.scrollIndicatorInsets = contentInsets
        // 현재 포커스가 있는 텍스트 필드가 화면에 가려져 있을 경우, 키보드가 올라올 때 해당 텍스트 필드를 보이도록 스크롤 하는 부분
        scrollView.scrollRectToVisible(websiteLinkTextField.frame, animated: true)
    }
    
    // MARK: - 키보드가 사라질 때 실행되는 함수
    @objc func keyboardWillHide(_ sender: Notification) {
        // 키보드가 사라질 때, 스크롤 뷰의 인셋을 초기화
        let contentInsets = UIEdgeInsets.zero
        // 스크롤 뷰의 컨텐츠 인셋을 설정
        scrollView.contentInset = contentInsets
        // 스크롤 뷰의 스크롤 인디케이터의 인셋을 설정
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    // MARK: - 키보드 툴바의 위 버튼을 눌렀을 때 실행되는 코드
    // 뷰 컨트롤러 내의 텍스트 필드와 텍스트 뷰를 순환하며 키보드 위에 툴바를 표시하고,
    // 툴바 내부의 위/아래 버튼을 클릭할 때마다 다음 또는 이전 객체를 선택할 수 있도록 구현된 코드
    
    @objc func upButtonTapped() {
        // 한 줄 프로필 텍스트 필드가 선택되어 있을 때 업 버튼을 누르면
        if oneLineProfileTextField.isFirstResponder {
            // 바로 위에 있는 닉네임 텍스트 필드에 포커스
            nicknameTextField.becomeFirstResponder()
        } else if aboutMeTextView.isFirstResponder {
            oneLineProfileTextField.becomeFirstResponder()
        }
    }
    
    // MARK: - 키보드 툴바의 아래 버튼을 눌렀을 때 실행되는 코드
    @objc func downButtonTapped() {
        if nicknameTextField.isFirstResponder {
            oneLineProfileTextField.becomeFirstResponder()
        } else if oneLineProfileTextField.isFirstResponder {
            aboutMeTextView.becomeFirstResponder()
        }
    }
    
    // MARK: - 특정 레이블(*)에 빨간색 옷을 입히는 코드
    func setLabels() {
        // 3개의 레이블에 공동 작업을 하기 위해 labels라는 하나의 값으로 합체
        let labels = [nicknameLabel, oneLineProfileLabel, aboutMeLabel]
        
        setupLabelsAppearance(labels: labels, string: "*", color: .red)
    }
    
    // MARK: - 5개의 텍스트 필드를 한꺼번에 꾸미는 코드
    func setTextFields() {
        // 5개의 텍스트 필드에 공동 작업을 하기 위해 textFields라는 하나의 값으로 합체
        let textFields = [
            nicknameTextField,
            oneLineProfileTextField,
            websiteLinkTextField,
            addSecondWebsiteLinkTextField,
            addThirdWebsiteLinkTextField
        ]
        
        // 적용할 텍스트 필드의 이름, 모서리 둥글기, 테두리 두께, 테두리 색상, 왼쪽과 오른쪽에 여백을 주는 함수
        setupTextFieldsAppearance(
            textFields: textFields,
            cornerRadius: 8,
            borderWidth: 1,
            borderColor: UIColor(red: 0.73, green: 0.74, blue: 0.75, alpha: 1.0),
            leftViewWidth: 16,
            rightViewWidth: 16
        )
    }
    
    // MARK: - 텍스트 뷰 꾸미는 코드
    func setTextView() {
        aboutMeTextView.layer.borderWidth = 1.0
        aboutMeTextView.layer.borderColor = UIColor(red: 0.73, green: 0.74, blue: 0.75, alpha: 1.0).cgColor
        aboutMeTextView.layer.cornerRadius = 8
        aboutMeTextView.textContainerInset = UIEdgeInsets(top: 16, left: 10, bottom: 16, right: 10)
    }
    
    // MARK: - 각 입력 필드의 글자 수를 업데이트하여 레이블에 출력
    func updateCountLabels() {
        nicknameCountLabel.text = "\(nicknameTextField.text?.count ?? 0) / 20"
        oneLineProfileCountLabel.text = "\(oneLineProfileTextField.text?.count ?? 0) / 30"
        aboutMeCountLabel.text = "\(aboutMeTextView.text?.count ?? 0) / 1000"
    }
    
    // MARK: - 주어진 문자열이 유효한 URL인지 여부를 판단하는 함수
    func
    isValidURL(urlString: String?) -> Bool {
        // 유효한 문자열인지, URL로 변환 가능한지 검사
        guard let urlString = urlString,
              let url = URL(string: urlString) else {
            return false
        }
        
        // 해당 URL을 열 수 있는지 여부를 검사하여 유효성을 판단
        return UIApplication.shared.canOpenURL(url)
    }
    
    // MARK: - 키보드 툴바 생성
    private func setToolbar() -> UIToolbar {
        // 입력창 상단에 위치할 툴바를 생성
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // 툴바 아이템 생성
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let upButton = UIBarButtonItem(image: UIImage(systemName: "chevron.up"), style: .plain, target: self, action: #selector(upButtonTapped))
        let downButton = UIBarButtonItem(image: UIImage(systemName: "chevron.down"), style: .plain, target: self, action: #selector(downButtonTapped))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonOnTheToolbar))
        
        // 툴바 아이템들을 배열에 저장하고 툴바에 추가
        toolbar.items = [upButton, downButton, flexibleSpace, doneButton]
        
        // 각 입력창에 툴바를 적용
        if let nicknameTextField = nicknameTextField {
            nicknameTextField.inputAccessoryView = toolbar
        }
        
        if let oneLineProfileTextField = oneLineProfileTextField {
            oneLineProfileTextField.inputAccessoryView = toolbar
        }
        
        if let aboutMeTextView = aboutMeTextView {
            aboutMeTextView.inputAccessoryView = toolbar
        }
        
        // doneButton이 활성화될지를 결정하는 메서드 호출
        doneButton.isEnabled = canEnableDoneButton()
        
        return toolbar
    }
    
    // MARK: - doneButton 활성화 여부를 판단하기 위한 함수
    private func canEnableDoneButton() -> Bool {
        // 각 textField에서 입력받은 text를 가져와서 nil이면 false 반환, text가 empty면 true 반환
        guard let nicknameText = nicknameTextField?.text,
                let oneLineProfileText = oneLineProfileTextField?.text,
                let aboutMeText = aboutMeTextView?.text else { return false }
        let isEmpty = nicknameText.isEmpty || oneLineProfileText.isEmpty || aboutMeText.isEmpty
        
        return !isEmpty
    }
    
    // MARK: - 키보드 툴바의 done 버튼을 탭하면 호출되는 함수
    @objc private func doneButtonOnTheToolbar() {
        // view에서 현재 first responder인 textField 또는 textView를 찾아서 키보드를 내림
        view.endEditing(true)
    }
    
    fileprivate func savedData() {
        // 텍스트 필드에 정보를 입력하고 완료를 누른 뒤, 다시 수정 화면으로 왔을 때 입력했던 정보들이 그대로 남아있게 하는 코드
        // savedData의 값이 nil이 아닌 경우 실행
        if let savedData = data {
            nicknameTextField.text = savedData.nickname                  // 닉네임 텍스트 필드에 입력된 데이터 저장
            oneLineProfileTextField.text = savedData.oneLineProfile      // 한 줄 프로필 텍스트 필드에 입력된 데이터 저장
            aboutMeTextView.text = savedData.aboutMe                     // 자기소개 텍스트 뷰에 입력된 데이터 저장
            websiteLinkTextField.text = savedData.firstWebsite           // 첫 번째 웹사이트 링크에 입력된 데이터 저장
            addSecondWebsiteLinkTextField.text = savedData.secondWebsite // 두 번째 웹사이트 링크에 입력된 데이터 저장
            addThirdWebsiteLinkTextField.text = savedData.thirdWebsite   // 세 번째 웹사이트 링크에 입력된 데이터 저장
        }
    }
    
    // MARK: - 웹사이트 추가 버튼 클릭했을 때
    @IBAction func addWebsiteButtonTapped(_ sender: UIButton) {
        
        // 만약 secondTextFieldStackView의 Hidden 값이 true라면
        if secondTextFieldStackView.isHidden {
            
            // secondTextFieldStackView의 Hidden 값을 false로 변경
            secondTextFieldStackView.isHidden = false
            
            // textFieldStackView의 하위 뷰로 추가
            textFieldStackView.addArrangedSubview(secondTextFieldStackView)
            
            // 만약 thirdTextFieldStackView의 Hidden 값이 true라면
        } else if thirdTextFieldStackView.isHidden {
            
            // thirdTextFieldStackView의 Hidden 값을 false로 변경
            thirdTextFieldStackView.isHidden = false
            
            // textFieldStackView의 하위 뷰로 추가
            textFieldStackView.addArrangedSubview(thirdTextFieldStackView)
            
            // 만약 더 이상 추가되지 않는다면 이미 3개의 뷰가 있는 상태이므로
        } else if textFieldStackView.arrangedSubviews.count >= 3 {
            
            // 경고 메시지 표시
            self.warningMessageLabel.isHidden = false
            
        }
        
    }
    
    // MARK: - 웹사이트 링크 삭제 버튼 클릭했을 때
    @IBAction func secondTextFieldDeleteButtonTapped(_ sender: UIButton) {
        // 만약 secondTextFieldStackView의 Hidden 값이 false라면
        if secondTextFieldStackView.isHidden == false {
            // 두 번째 웹사이트 텍스트 필드의 텍스트를 빈 문자열로 변경
            addSecondWebsiteLinkTextField.text = ""
            // secondTextFieldStackView의 Hidden 값을 true로 변경
            secondTextFieldStackView.isHidden = true
        }
    }
    
    @IBAction func thirdTextFieldDeleteButtonTapped(_ sender: UIButton) {
        if thirdTextFieldStackView.isHidden == false {
            addThirdWebsiteLinkTextField.text = ""
            thirdTextFieldStackView.isHidden = true
        }
    }
    
    // MARK: - 완료 버튼 클릭했을 때
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        // 닉네임, 한 줄 프로필, 자기소개가 모두 채워져 있고, 웹사이트 입력칸이 모두 비어있는 경우
        if !(nicknameTextField.text?.isEmpty ?? true) &&
            !(oneLineProfileTextField.text?.isEmpty ?? true) &&
            !aboutMeTextView.text.isEmpty &&
            websiteLinkTextField.text?.isEmpty ?? true &&
            addSecondWebsiteLinkTextField.text?.isEmpty ?? true &&
            addThirdWebsiteLinkTextField.text?.isEmpty ?? true {
            // 화면 닫음
            dismiss(animated: true)
          // 닉네임, 한 줄 프로필, 자기 소개글이 모두 채워져 있고, 웹사이트 입력칸이 하나 이상 채워져 있으며, 웹사이트가 올바른 URL인 경우
        } else if !(nicknameTextField.text?.isEmpty ?? true) &&
                    !(oneLineProfileTextField.text?.isEmpty ?? true) &&
                    !aboutMeTextView.text.isEmpty &&
                    !(websiteLinkTextField.text?.isEmpty ?? true) && isValidURL(urlString: websiteLinkTextField.text) &&
                    (addSecondWebsiteLinkTextField.text?.isEmpty ?? true || isValidURL(urlString: addSecondWebsiteLinkTextField.text)) &&
                    (addThirdWebsiteLinkTextField.text?.isEmpty ?? true || isValidURL(urlString: addThirdWebsiteLinkTextField.text)) {
            // 화면 닫음
            dismiss(animated: true)
          // 입력된 값이 올바르지 않은 경우
        } else {
            // ValidationViewController를 화면에 표시
            if let validationViewController = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: "ValidationViewController") as? ValidationViewController {
                presentPanModal(validationViewController)
                
                // 닉네임이 비어있는 경우
                if let nickname = nicknameTextField.text, nickname.isEmpty {
                    validationViewController.nicknameValidationLabel?.isHidden = false
                } else {
                    validationViewController.nicknameValidationLabel?.isHidden = true
                }
                
                // 한 줄 프로필이 비어있는 경우
                if let oneLineProfile = oneLineProfileTextField.text, oneLineProfile.isEmpty {
                    validationViewController.oneLineProfileValidationLabel?.isHidden = false
                } else {
                    validationViewController.oneLineProfileValidationLabel?.isHidden = true
                }
                
                // 자기소개가 비어있는 경우
                if let aboutMe = aboutMeTextView.text, aboutMe.isEmpty {
                    validationViewController.aboutMeValidationLabel?.isHidden = false
                } else {
                    validationViewController.aboutMeValidationLabel?.isHidden = true
                }
                
                // 모든 링크가 유효한지를 담고 있는 변수
                var hasValidWebsiteLinks = true
                
                // 첫 번째 웹사이트가 올바른 URL이 아닌 경우
                if let firstWebsite = websiteLinkTextField.text, !firstWebsite.isEmpty {
                    hasValidWebsiteLinks = hasValidWebsiteLinks && isValidURL(urlString: firstWebsite)
                }
                
                // 두 번째 웹사이트가 올바른 URL이 아닌 경우
                if let secondWebsite = addSecondWebsiteLinkTextField.text, !secondWebsite.isEmpty {
                    hasValidWebsiteLinks = hasValidWebsiteLinks && isValidURL(urlString: secondWebsite)
                }
                
                // 세 번째 웹사이트가 올바른 URL이 아닌 경우
                if let thirdWebsite = addThirdWebsiteLinkTextField.text, !thirdWebsite.isEmpty {
                    hasValidWebsiteLinks = hasValidWebsiteLinks && isValidURL(urlString: thirdWebsite)
                }
                
                // 입력된 웹사이트 링크가 유효한지 검증하고, 유효하지 않은 링크가 있다면 화면에 에러 메시지를 보여주는 코드
                // 만약 hasValidWebsiteLinks가 false 라면
                if !hasValidWebsiteLinks {
                    // validationViewController의 websiteValidationLabel을 보이도록 설정
                    validationViewController.websiteValidationLabel?.isHidden = false
                } else {
                    // 그렇지 않으면, validationViewController의 websiteValidationLabel을 숨기도록 설정
                    validationViewController.websiteValidationLabel?.isHidden = true
                }
            }
        }
        
        // 만약 현재 뷰를 호출한 뷰 컨트롤러가 MainViewController라면
        if let mainViewController = presentingViewController as? MainViewController {
            // mainViewController의 updateData 함수를 호출해서 튜플로 저장할 데이터를 만들어 전달
            mainViewController.updateData(
                savedData: (
                    nicknameTextField.text ?? "",
                    oneLineProfileTextField.text ?? "",
                    aboutMeTextView.text ?? "",
                    websiteLinkTextField.text ?? "",
                    addSecondWebsiteLinkTextField.text ?? "",
                    addThirdWebsiteLinkTextField.text ?? ""
                )
            )
            
            // 첫 번째 웹사이트가 비었을 경우, MainViewController의 해당 레이블을 숨김
            mainViewController.hiddenWebsite.isHidden = websiteLinkTextField.text?.isEmpty ?? true
            // 첫 번째 웹사이트가 비었을 경우, MainViewController의 해당 뷰를 숨김
            mainViewController.firstWebsiteView.isHidden = websiteLinkTextField.text?.isEmpty ?? true
            // 두 번째 웹사이트가 비었을 경우, MainViewController의 해당 뷰를 숨김
            mainViewController.secondWebsiteView.isHidden = addSecondWebsiteLinkTextField.text?.isEmpty ?? true
            // 세 번째 웹사이트가 비었을 경우, MainViewController의 해당 뷰를 숨김
            mainViewController.thirdWebsiteView.isHidden = addThirdWebsiteLinkTextField.text?.isEmpty ?? true
            
            // 첫 번째 웹사이트 텍스트 필드에 입력된 텍스트를 MainViewController에서 첫 번째 웹사이트 레이블의 텍스트로 설정
            mainViewController.firstWebsiteLabel?.text = websiteLinkTextField.text
            // 두 번째 웹사이트 텍스트 필드에 입력된 텍스트를 MainViewController에서 두 번째 웹사이트 레이블의 텍스트로 설정
            mainViewController.secondWebsiteLabel.text = addSecondWebsiteLinkTextField.text
            // 세 번째 웹사이트 텍스트 필드에 입력된 텍스트를 MainViewController에서 세 번째 웹사이트 레이블의 텍스트로 설정
            mainViewController.thirdWebsiteLabel.text = addThirdWebsiteLinkTextField.text
        }
    }
}

// MARK: - Extension
extension UILabel {
    // 텍스트 색상 설정
    func setTextColor(string: String, color: UIColor) {
        // 만약 text가 nil이면 빈 문자열("")을 할당
        let fullText = text ?? ""
        // NSMutableAttributedString을 fullText로 초기화하여 attributedString에 할당
        let attributedString = NSMutableAttributedString(string: fullText)
        // NSString의 range(of:) 메서드를 사용하여 NSRange 타입의 범위를 반환
        let range = (fullText as NSString).range(of: string)
        // .foregroundColor 속성을 추가하고 속성 값을 파라미터로 받은 color로 설정
        attributedString.addAttribute(.foregroundColor, value: color, range: range)
        // UILabel의 attributedText 속성을 attributedString으로 설정하여 텍스트 색상이 적용된 텍스트가 표시
        attributedText = attributedString
    }
}

extension UIViewController {
    // 레이블의 외형을 설정하는 함수
    func setupLabelsAppearance(labels: [UILabel?], string: String, color: UIColor) {
        // 배열 labels 안에 있는 각 레이블에 대해 반복 실행
        for label in labels {
            // 문자열이 포함된 텍스트를 color로 변경하는 코드
            label?.setTextColor(string: string, color: color)
        }
    }
    
    // 여백을 터치헸을 때 키보드가 내려가는 함수
    func hideKeyboardWhenTappedAround() {
        // UITapGestureRecognizer 객체 생성
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        // UIView의 다른 부분을 탭해도 키보드가 내려가도록 설정
        tap.cancelsTouchesInView = false
        // UIView에 제스처 인식기 추가
        view.addGestureRecognizer(tap)
    }
    
    // 제스처 인식기에서 사용할 함수
    @objc func dismissKeyboard() {
        // UIView의 모든 서브 뷰에서 키보드를 내림
        view.endEditing(true)
    }
}

// MARK: - TextFieldDelegate
extension EditViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // 닉네임 텍스트 필드를 편집하는 경우
        if let nicknameTextField = nicknameTextField, textField == nicknameTextField {
            // 키보드 상단에 툴바 설정
            textField.inputAccessoryView = setToolbar()
            if let toolbar = textField.inputAccessoryView as? UIToolbar {
                // 키보드 툴바가 첫 번째 아이템이면 위 버튼 비활성화
                if let upButton = toolbar.items?[0] {
                    upButton.isEnabled = false
                }
            }
          // 한 줄 프로필 텍스트 필드를 편집하는 경우
        } else if let oneLineProfileTextField = oneLineProfileTextField, textField == oneLineProfileTextField {
            // 키보드 상단에 toolbar 설정
            textField.inputAccessoryView = setToolbar()
          // 자기소개 텍스트 뷰를 편집하는 경우
        } else if let aboutMeTextView = aboutMeTextView, textField == aboutMeTextView {
            // 키보드 상단에 toolbar 설정
            textField.inputAccessoryView = setToolbar()
        }
        // true를 반환하여 현재 textField가 편집될 수 있도록 함
        return true
    }
    
    // 텍스트 필드를 꾸미는 함수
    func setupTextFieldsAppearance(
        // 설정할 텍스트 필드 배열
        textFields: [UITextField?],
        // 텍스트 필드의 모서리 둥글기
        cornerRadius: CGFloat,
        // 텍스트 필드의 테두리 두께
        borderWidth: CGFloat,
        // 텍스트 필드의 테두리 색상
        borderColor: UIColor,
        // 텍스트 필드의 왼쪽 여백
        leftViewWidth: CGFloat,
        // 텍스트 필드의 오른쪽 여백
        rightViewWidth: CGFloat
    ) {
        // 반복문을 통해 배열에 있는 텍스트 필드들의 속성 값을 각각의 파라미터 값에 해당되도록 설정
        for textField in textFields {
            textField?.layer.cornerRadius = cornerRadius
            textField?.layer.borderWidth = borderWidth
            textField?.layer.borderColor = borderColor.cgColor
            textField?.leftView = UIView(frame: CGRect(x: 0, y: 0, width: leftViewWidth, height: 0))
            textField?.leftViewMode = .always
            textField?.rightView = UIView(frame: CGRect(x: 0, y: 0, width: rightViewWidth, height: 0))
            textField?.rightViewMode = .always
        }
    }
    
    // 텍스트 필드가 선택되고 사용자가 입력을 시작했을 때 호출
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // 현재 선택된 텍스트 필드를 first responder로 만들어 키보드가 표시되도록 함
        textField.becomeFirstResponder()
        // 텍스트 필드의 테두리 굵기 설정
        textField.layer.borderWidth = 1
        // 텍스트 필드가 포커스 되었을 때 테두리 색
        textField.layer.borderColor = UIColor.systemBlue.cgColor
        
        // 현재 선택된 텍스트 필드가 닉네임 텍스트 필드인 경우
        if textField == nicknameTextField {
            // 닉네임 텍스트 필드의 키보드 액세서리 뷰의 첫 번째 버튼을 가져와서 비활성화
            if let toolbar = nicknameTextField?.inputAccessoryView as? UIToolbar {
                if let upButton = toolbar.items?[0] {
                    upButton.isEnabled = false
                }
            }
        } else {
            // 현재 선택된 텍스트 필드의 키보드 액세서리 뷰의 첫 번째와 두 번째 버튼을 가져와서 활성화
            if let toolbar = textField.inputAccessoryView as? UIToolbar {
                if let upButton = toolbar.items?[0], let downButton = toolbar.items?[1] {
                    upButton.isEnabled = true
                    downButton.isEnabled = true
                }
            }
        }
    }
    
    // 텍스트 필드의 편집이 끝난 후 호출되는 함수
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor(red: 0.73, green: 0.74, blue: 0.75, alpha: 1.0).cgColor
    }
    
    // 텍스트 필드에 새로운 문자열이 입력될 때마다 호출되는 델리게이트 메서드(입력 제한을 구현하는 데 사용)
    // • 매개변수 textField는 UITextField 객체를 전달
    // • 매개변수 range는 새로운 문자열을 추가하려는 범위를 나타내는 NSRange 객체
    // • 매개변수 string은 새로운 문자열
    // • 메서드가 반환하는 Bool 값은 새로운 문자열을 텍스트 필드에 추가할 것인지에 대한 여부
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 현재 텍스트 필드의 텍스트를 가져와서, 문자열 변수에 할당
        // textField.text가 nil이 아닌 경우 이후의 코드를 실행
        guard let text = textField.text else { return true }
        
        // 새로운 문자열의 길이를 계산
        // 이때, 기존의 문자열의 길이와 range.length 값을 빼고 새로운 문자열의 길이를 더한다.
        let newLength = text.count + string.count - range.length
        
        switch textField {
        case nicknameTextField:
            // UserDefaults에 현재 입력한 닉네임의 길이를 저장
            let textCount = UserDefaults.standard
            textCount.set(newLength, forKey: "nicknameCount")
            // 닉네임의 길이가 20자 이하인 경우에만 true를 반환하여 입력이 가능하게 함
            return newLength <= 20
        case oneLineProfileTextField:
            // UserDefaults에 현재 입력한 한 줄 프로필의 길이를 저장
            let textCount = UserDefaults.standard
            textCount.set(newLength, forKey: "oneLineProfileCount")
            // 한 줄 프로필의 길이가 30자 이하인 경우에만 true를 반환하여 입력이 가능하게 함
            return newLength <= 30
        default:
            // 기본적으로 true를 반환하여 입력이 가능하게 함
            return true
        }
        
    }
    
    // 텍스트 필드가 변경될 때마다 호출되는 함수
    func textFieldDidChangeSelection(_ textField: UITextField) {
        updateCountLabels()
        
        if canEnableDoneButton() {
            if let toolbar = textField.inputAccessoryView as? UIToolbar, let doneButton = toolbar.items?.last {
                doneButton.isEnabled = true
            }
        } else {
            if let toolbar = textField.inputAccessoryView as? UIToolbar, let doneButton = toolbar.items?.last {
                doneButton.isEnabled = false
            }
        }
    }
}

// MARK: - TextViewDelegate
extension EditViewController: UITextViewDelegate {
    // 텍스트가 변경될 때마다 호출되는 UITextViewDelegate 프로토콜 메서드(새로운 텍스트가 추가되거나 기존 텍스트가 삭제될 때마다 호출)
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // 현재 텍스트 뷰에 있는 텍스트를 가져와 currentText 상수에 할당
        // 만약 textView.text가 nil이면 빈 문자열을 할당
        let currentText = textView.text ?? ""
        // NSRange 객체를 currentText 문자열 범위로 변환하여 stringRange에 할당
        // range가 currentText 문자열 범위 밖이면 false를 반환
        guard let stringRange = Range(range, in: currentText) else { return false }
        // 새로운 문자열인 changedText에 currentText 문자열에서 stringRange 범위 내의 문자들을 text로 교체
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        // changedText 문자열의 문자 수가 1,000자 이하인 경우 true를 반환하고 1,000보다 큰 경우 false를 반환
        return changedText.count <= 1_000
    }
    
    // 텍스트뷰 편집이 시작될 때 실행되는 함수
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.becomeFirstResponder()
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.systemBlue.cgColor
        
        // textView의 텍스트가 비어있다면
        if textView.text.isEmpty {
            // placeholder를 숨김
            textViewPlaceholder.isHidden = true
        }
        
        if textView == aboutMeTextView {
            if let toolbar = textView.inputAccessoryView as? UIToolbar {
                if let upButton = toolbar.items?[0], let downButton = toolbar.items?[1] {
                    upButton.isEnabled = true
                    downButton.isEnabled = false
                }
            }
        }
    }
    
    // 텍스트뷰의 내용이 변경될 때 실행되는 함수
    func textViewDidChange(_ textView: UITextView) {
        // textView가 변경될 때마다 updateTextViewCountLabel 함수를 호출하여 문자 수 업데이트
        updateCountLabels()
        // textView에 텍스트가 있으면 placeholder를 숨김
        textViewPlaceholder.isHidden = !textView.text.isEmpty
        
        if canEnableDoneButton() {
            if let toolbar = textView.inputAccessoryView as? UIToolbar, let doneButton = toolbar.items?.last {
                doneButton.isEnabled = true
            }
        } else {
            if let toolbar = textView.inputAccessoryView as? UIToolbar, let doneButton = toolbar.items?.last {
                doneButton.isEnabled = false
            }
        }
    }
    
    // 텍스트뷰 편집이 종료될 때 실행되는 함수
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.layer.borderColor = UIColor(red: 0.73, green: 0.74, blue: 0.75, alpha: 1.0).cgColor
        
        // textView의 텍스트가 비어있다면
        if textView.text.isEmpty {
            // placeholder를 보이게 함
            textViewPlaceholder.isHidden = false
        }
    }
}
