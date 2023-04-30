//
//  ValidationViewController.swift
//  01_Portfolio
//
//  Created by Raphael Shim on 2023/04/18.
//

import UIKit
import PanModal

class ValidationViewController: UIViewController {
    @IBOutlet weak var nicknameValidationLabel: UILabel!
    @IBOutlet weak var oneLineProfileValidationLabel: UILabel!
    @IBOutlet weak var aboutMeValidationLabel: UILabel!
    @IBOutlet weak var websiteValidationLabel: UILabel!
    @IBOutlet weak var validationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func validationButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

extension ValidationViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }
    
    var shortFormHeight: PanModalHeight {
        // 현재 화면에 보이는 validation label의 개수에 따라 화면 높이를 결정
        let visibleValidationLabelsCount = [
            nicknameValidationLabel,
            oneLineProfileValidationLabel,
            aboutMeValidationLabel,
            websiteValidationLabel
        ].filter { $0?.isHidden == false }.count
        
        switch visibleValidationLabelsCount {
        case 1:
            return .contentHeight(200)
        case 2:
            return .contentHeight(235)
        case 3:
            return .contentHeight(270)
        case 4:
            return .contentHeight(305)
        default:
            return .contentHeight(270)
        }
    }

    var longFormHeight: PanModalHeight {
        // 기본적으로 short form height와 동일
        return shortFormHeight
    }

    var anchorModalToLongForm: Bool {
        // long form이 설정되어 있지 않으므로 false를 반환
        return false
    }
}
