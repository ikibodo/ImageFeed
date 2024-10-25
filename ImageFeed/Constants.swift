//
//  Untitled.swift
//  ImageFeed
//
//  Created by N L on 24.10.24..
//

import Foundation

enum Constants {
    static let accessKey = "<CzbUBdie8v6_fiHgtQnVZRL4Am8fa9tsx3db_Fd_TyA>"
    static let secretKey = "<bqNTwbzNWLhw3sfdpx9L1Bt4aE7TUBS4LSvveoOOUac>"
    static let redirectURI = "<urn:ietf:wg:oauth:2.0:oob>"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com/")! // небезопасная распаковка - надо изменить
}
