//
//  SettingsVC.swift
//  EchocodeTranslator
//
//  Created by Chmil Oleksandr on 17/04/2025.
//

import UIKit
import StoreKit
import SafariServices

class SettingsVC: UIViewController {
    
    // MARK: - Header title
    private let headerTitle = ETLabel(textColor: .colorBlack, fontSize: 32, text: "Settings", weight: .regular, fontName: "KonkhmerSleokchher-Regular", textAlignment: .center)
    
    // MARK: - Settings + btns
    private let settingsStack: UIStackView = {
        let stck = UIStackView()
        stck.axis = .vertical
        stck.spacing = 14
        return stck
    }()
    private var rateUsBtn = ETSettingsBtn(title: "Rate Us")
    private var shareAppBtn = ETSettingsBtn(title: "Share App")
    private var contactBtn = ETSettingsBtn(title: "Contact Us")
    private var restPurchBtn = ETSettingsBtn(title: "Restore Purchases")
    private var privacyPolBtn = ETSettingsBtn(title: "Privacy Policy")
    private var termsOfUseBtn = ETSettingsBtn(title: "Terms of Use")
    
    // MARK: - Gradient
    override func loadView() {
        super.loadView()
        view = ETLinearGradientView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        setupActions()
    }
    
    private func configureLayout() {
        [headerTitle, settingsStack].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        // Stack
        [rateUsBtn, shareAppBtn, contactBtn, restPurchBtn, privacyPolBtn, termsOfUseBtn].forEach {
            settingsStack.addArrangedSubview($0)
            $0.heightAnchor.constraint(equalToConstant: 50).isActive = true

        }
        
        // Setup constraints
        NSLayoutConstraint.activate([
            //headerTitle
            headerTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            headerTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            
            //settingsStack
            settingsStack.topAnchor.constraint(equalTo: headerTitle.bottomAnchor, constant: 12),
            settingsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            settingsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
        ])
    }
    // MARK: - Actions
    private func setupActions() {
        rateUsBtn.addTarget(self, action: #selector(rateAppTapped), for: .touchUpInside)
        shareAppBtn.addTarget(self, action: #selector(shareAppBtnTapped), for: .touchUpInside)
        contactBtn.addTarget(self, action: #selector(contactBtnTapped), for: .touchUpInside)
        restPurchBtn.addTarget(self, action: #selector(restorePurchasesTapped), for: .touchUpInside)
        privacyPolBtn.addTarget(self, action: #selector(privacyPolBtnTapped), for: .touchUpInside)
        termsOfUseBtn.addTarget(self, action: #selector(termsOfUseBtnTapped), for: .touchUpInside)
        
    }
    
    // MARK: - Button actions
    @objc private func rateAppTapped() {
        if let windowScene = view.window?.windowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
    @objc private func shareAppBtnTapped() {

        let appURL = URL(string: "https://apps.apple.com/app/telegram-messenger/id686449807")!
        
    
        let items: [Any] = ["Check out this awesome app!", appURL]
        
   
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
     
        if let popoverController = activityVC.popoverPresentationController {
            popoverController.sourceView = shareAppBtn
            popoverController.sourceRect = shareAppBtn.bounds
        }
        
       
        present(activityVC, animated: true, completion: nil)
    }
    @objc func contactBtnTapped() {
       
        let telegramUsername = "riggs8"
        if let url = URL(string: "https://t.me/\(telegramUsername)") {
            if UIApplication.shared.canOpenURL(url) {
             
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                
                let alertController = UIAlertController(title: "Error", message: "Telegram is not installed on your device.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alertController, animated: true, completion: nil)
            }
        }
    }

    @objc func restorePurchasesTapped() {
        Task {
            do {
                try await AppStore.sync()
                await showSuccessAlert()
            } catch {
                
                if error.localizedDescription.contains("ERROR_CANCELLED_DESC") || error.localizedDescription.contains("Request Canceled")  {
                    print("\(error.localizedDescription)")
                    return
                }
    
                print("Ошибка синхронизации: \(error)")
                await showErrorAlert(message: "Ошибка синхронизации: \(error.localizedDescription)")
            }
        }
    }
        private func showSuccessAlert() async {
            let alert = UIAlertController(title: "Успех", message: "Синхронизация прошла успешно.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ок", style: .default))
            await MainActor.run {
                self.present(alert, animated: true)
            }
        }
        private func showErrorAlert(message: String) async {
            let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ок", style: .default))
            await MainActor.run {
                self.present(alert, animated: true)
            }
        }
    
    @objc func privacyPolBtnTapped() {
        guard let url = URL(string: "https://www.duolingo.com/privacy?wantsPlainInfo=1") else { return }
        openSafariViewController(with: url)
    }
    @objc func termsOfUseBtnTapped() {
           guard let url = URL(string: "https://www.duolingo.com/terms?wantsPlainInfo=1") else { return }
        openSafariViewController(with: url)
       }

    private func openSafariViewController(with url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.delegate = self
        present(safariVC, animated: true, completion: nil)
    }

}
extension SettingsVC: SFSafariViewControllerDelegate {

    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        // Closing the Safari View Controller when the user taps "Done
        controller.dismiss(animated: true, completion: nil)
    }
}
