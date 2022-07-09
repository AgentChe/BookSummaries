//
//  SettingsViewModel.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 09.07.2022.
//

import RxSwift
import RxCocoa

final class SettingsViewModel {
    lazy var elements = makeElements()
}

// MARK: Private
private extension SettingsViewModel {
    func makeElements() -> Driver<[SettingsTableElement]> {
        .deferred {
            Driver<[SettingsTableElement]>.just([
                .contactUs("Settings.ContactUs".localized),
                .offset(20.scale),
                .separator,
                .offset(20.scale),
                .contactUs("Settings.PrivacyPolicy".localized),
                .offset(20.scale),
                .separator,
                .offset(20.scale),
                .contactUs("Settings.TermsOfUse".localized),
            ])
        }
    }
}
