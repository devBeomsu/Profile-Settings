//
//  MainViewController.swift
//  01_Portfolio
//
//  Created by Raphael Shim on 2023/03/29.
//

import UIKit
import SafariServices

class MainViewController: UIViewController {
    @IBOutlet weak var nicknameView: CustomView!       // 별도의 색상과 테두리가 있는 뷰
    @IBOutlet weak var oneLineProfileView: CustomView! // 별도의 색상과 테두리가 있는 뷰
    @IBOutlet weak var aboutMeView: CustomView!        // 별도의 색상과 테두리가 있는 뷰
    @IBOutlet weak var popUpButton: CustomButton!      // 별도의 색상과 테두리가 있는 버튼
    
    @IBOutlet weak var nicknameLabel: UILabel!       // 닉네임을 표시하는 레이블
    @IBOutlet weak var oneLineProfileLabel: UILabel! // 한 줄 프로필을 표시하는 레이블
    @IBOutlet weak var aboutMeLabel: UILabel!        // 자기 소개를 표시하는 레이블
    
    @IBOutlet weak var hiddenWebsite: UILabel! // 숨겨진 "연결된 웹사이트" 레이블
    
    @IBOutlet weak var firstWebsiteView: CustomView!  // 첫 번째 웹사이트 링크를 감싸는 뷰
    @IBOutlet weak var secondWebsiteView: CustomView! // 두 번째 웹사이트 링크를 감싸는 뷰
    @IBOutlet weak var thirdWebsiteView: CustomView!  // 세 번째 웹사이트 링크를 감싸는 뷰
    
    @IBOutlet weak var firstWebsiteLabel: UILabel!
    @IBOutlet weak var secondWebsiteLabel: UILabel! // 두 번째 웹사이트 링크
    @IBOutlet weak var thirdWebsiteLabel: UILabel!  // 세 번째 웹사이트 링크
    
    // 기본 인스턴스를 초기화하고, 이를 defaults 상수에 할당
    // defaults를 사용하여 데이터를 저장하고 가져올 수 있음
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // UserDefaults를 사용하여 이전에 저장한 데이터를 불러오고, 각각의 데이터를 해당하는 레이블에 출력하는 코드
        nicknameLabel.text = defaults.string(forKey: "nickname")
        oneLineProfileLabel.text = defaults.string(forKey: "oneLineProfile")
        aboutMeLabel.text = defaults.string(forKey: "aboutMe")
        firstWebsiteLabel.text = defaults.string(forKey: "firstWebsite")
        secondWebsiteLabel.text = defaults.string(forKey: "secondWebsite")
        thirdWebsiteLabel.text = defaults.string(forKey: "thirdWebsite")
        
        // MARK: 연결한 웹사이트가 있으면 Hidden 처리하지 않는 코드
        if firstWebsiteLabel.text?.isEmpty == false &&
            secondWebsiteLabel.text?.isEmpty == false &&
            thirdWebsiteLabel.text?.isEmpty == false {
            firstWebsiteView.isHidden = false
            secondWebsiteView.isHidden = false
            thirdWebsiteView.isHidden = false
            
            firstWebsiteLabel.underline()
            secondWebsiteLabel.underline()
            thirdWebsiteLabel.underline()
        } else {
            firstWebsiteView.isHidden = true
            secondWebsiteView.isHidden = true
            thirdWebsiteView.isHidden = true
        }
        
        // MARK: 웹사이트 링크에 탭 제스처 추가
        let firstWebsiteLabelTapGesture = UITapGestureRecognizer(target: self, action: #selector(firstWebsiteLabelTapped))
        firstWebsiteLabel.addGestureRecognizer(firstWebsiteLabelTapGesture)
        firstWebsiteLabel.isUserInteractionEnabled = true
        
        let secondWebsiteLabelTapGesture = UITapGestureRecognizer(target: self, action: #selector(secondWebsiteLabelTapped))
        secondWebsiteLabel.addGestureRecognizer(secondWebsiteLabelTapGesture)
        secondWebsiteLabel.isUserInteractionEnabled = true
        
        let thirdWebsiteLabelTapGesture = UITapGestureRecognizer(target: self, action: #selector(thirdWebsiteLabelTapped))
        thirdWebsiteLabel.addGestureRecognizer(thirdWebsiteLabelTapGesture)
        thirdWebsiteLabel.isUserInteractionEnabled = true
    }
    
    // MARK: - 웹사이트 링크 레이블을 클릭했을 때 호출되는 셀렉터 메서드
    @objc private func firstWebsiteLabelTapped() {
        let urlString = firstWebsiteLabel.text
        guard let url = URL(string: urlString!) else { return }
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true)
    }
    
    @objc private func secondWebsiteLabelTapped() {
        let urlString = secondWebsiteLabel.text
        guard let url = URL(string: urlString!) else { return }
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true)
    }
    
    @objc private func thirdWebsiteLabelTapped() {
        let urlString = thirdWebsiteLabel.text
        guard let url = URL(string: urlString!) else { return }
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true)
    }
    
    // MARK: - 작성 팝업 띄우기 버튼을 눌렀을 때 실행되는 액션
    @IBAction func popUpButtonTapped(_ sender: UIButton) {
        // "Main" 스토리보드에서 "EditViewController" 인스턴스를 가져옴
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let editViewController = storyboard.instantiateViewController(withIdentifier: "EditViewController") as! EditViewController
        
        // 모달 전환 스타일과 프레젠테이션 스타일 설정
        editViewController.modalTransitionStyle = .coverVertical
        editViewController.modalPresentationStyle = .fullScreen
        // 현재 레이블에 표시되는 정보들을 튜플 형태로 데이터에 담아 EditViewController의 data 속성으로 전달
        editViewController.data = (
            nicknameLabel.text ?? "",
            oneLineProfileLabel.text ?? "",
            aboutMeLabel.text ?? "",
            firstWebsiteLabel.text ?? "",
            secondWebsiteLabel.text ?? "",
            thirdWebsiteLabel.text ?? ""
        )
        
        // editViewController를 모달로 전환
        present(editViewController, animated: true, completion: nil)
    }
    
    // MARK: - 저장된 데이터를 업데이트하기 위한 함수
    func updateData(savedData: (
        nickname: String,       // 저장된 닉네임 데이터
        oneLineProfile: String, // 저장된 한 줄 프로필 데이터
        aboutMe: String,        // 저장된 자기소개 데이터
        firstWebsite: String,   // 저장된 첫 번째 웹사이트 링크 데이터
        secondWebsite: String,  // 저장된 두 번째 웹사이트 링크 데이터
        thirdWebsite: String    // 저장된 세 번째 웹사이트 링크 데이터
    )?) {
        // 저장된 데이터가 있다면
        if let data = savedData {
            // 레이블에 저장된 데이터를 업데이트
            nicknameLabel.text = data.nickname             // 닉네임 레이블에 저장된 닉네임 데이터 업데이트
            oneLineProfileLabel.text = data.oneLineProfile // 한 줄 소개 레이블에 저장된 한 줄 소개 데이터 업데이트
            aboutMeLabel.text = data.aboutMe               // 자기 소개 레이블에 저장된 자기 소개 데이터 업데이트
            firstWebsiteLabel.text = data.firstWebsite
            secondWebsiteLabel.text = data.secondWebsite   // 두 번째 웹사이트 레이블에 저장된 두 번째 웹사이트 링크 데이터 업데이트
            thirdWebsiteLabel.text = data.thirdWebsite     // 세 번째 웹사이트 레이블에 저장된 세 번째 웹사이트 링크 데이터 업데이트
        }
    }
}

// MARK: - 해당 인스턴스의 텍스트를 밑줄 처리하는 기능
extension UILabel {
    func underline() {
        // self.text 속성에 값이 있는 경우(즉, 레이블에 텍스트가 있는 경우)에만 아래의 코드를 실행
        if let textUnwrapped = self.text {
            let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
            let underlineAttributedString = NSAttributedString(string: textUnwrapped, attributes: underlineAttribute)
            self.attributedText = underlineAttributedString
        }
    }
}
