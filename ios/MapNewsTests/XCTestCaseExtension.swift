//
//  XCTestCaseExtension.swift
//  MapNewsTests
//
//  Created by Hol Yin Ho on 2/7/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//
import XCTest

extension XCTestCase {
    func tap(button: UIButton) {
        button.sendActions(for: .touchUpInside)
    }

    func tap(textField: UITextField) {
        textField.sendActions(for: .touchUpInside)
    }
}
