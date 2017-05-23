//
//  Utility.swift
//  TinTinApp_iOS
//
//  Created by Hsieh Kai Yang on 2017/5/23.
//  Copyright © 2017年 Hsieh Kai Yang. All rights reserved.
//

import Foundation

class Utility{
    func convertStringToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
