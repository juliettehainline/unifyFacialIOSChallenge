//
//  KeychainService.swift
//  unifyIdCodingChallenge
//
//  Created by Juliette Hainline on 11/3/17.
//  Copyright © 2017 Juliette Hainline. All rights reserved.
//
//  Source: https://stackoverflow.com/questions/37539997/save-and-load-from-keychain-swift/37539998#37539998

import Foundation
import UIKit
import Security

// Constant Identifiers
let userAccount = "AuthenticatedUser"
let accessGroup = "SecuritySerivice"


/**
 *  User defined keys for new entry
 *  Note: add new keys for new secure item and use them in load and save methods
 */

let passwordKey = "KeyForPassword"

// Arguments for the keychain queries
let kSecClassValue = NSString(format: kSecClass)
let kSecAttrAccountValue = NSString(format: kSecAttrAccount)
let kSecValueDataValue = NSString(format: kSecValueData)
let kSecClassGenericPasswordValue = NSString(format: kSecClassGenericPassword)
let kSecAttrServiceValue = NSString(format: kSecAttrService)
let kSecMatchLimitValue = NSString(format: kSecMatchLimit)
let kSecReturnDataValue = NSString(format: kSecReturnData)
let kSecMatchLimitOneValue = NSString(format: kSecMatchLimitOne)

public class KeychainService: NSObject {
    
    /**
     * Exposed methods to perform save and load queries.
     */
    
    public class func savePhoto(token: UIImage) {
        let imageData: NSData = UIImagePNGRepresentation(token)! as NSData
        self.save(service: passwordKey as NSString, info: imageData)
    }
    
    /**
     * Internal methods for querying the keychain.
     */
    
    private class func save(service: NSString, info: NSData) {
        // Instantiate a new default keychain query
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, userAccount, info], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecValueDataValue])
        
        // Delete any existing items
        SecItemDelete(keychainQuery as CFDictionary)
        
        // Add the new keychain item
        SecItemAdd(keychainQuery as CFDictionary, nil)
    }
}
