
import Foundation

/// Documentaion
/// These lets are the keys that are used in the Keychain API.
/// They are used in the KeychainHelper class.
private let secClass = kSecClass as String
private let secAttrService = kSecAttrService as String
private let secAttrGeneric = kSecAttrGeneric as String
private let secAttrAccount = kSecAttrAccount as String
private let secMatchLimit = kSecMatchLimit as String
private let secReturnData = kSecReturnData as String
private let secValueData = kSecValueData as String
private let secAttrAccessible = kSecAttrAccessible as String

public protocol KeychainHelperProtocol {
    static func create(cfDictionary: CFDictionary) -> Bool
    static func update(cfDictionary: CFDictionary) -> Bool
    static func remove(cfDictionary: CFDictionary) -> Bool
    static func search(matching cfDictionary: CFDictionary) -> Data?
}
/// Documentaion
/// The 'KeychainHelper' class is a wrapper around the Keychain API that helps to make working with Keychain API a little easier.
/// It has different methods for saving, retrieving, updating and deleting items from the Keychain.
/// It has some public and some private methods. The public methods are the ones that you will use in your code.
/// The private methods are there to help the public methods.
/// The public methods are:
///
/// 1. create(value: String, forIdentifier identifier: String) -> Bool
/// Parameters:
/// value: The value to be saved in the Keychain.
/// identifier: The identifier to be used to uniquely identify the value in the Keychain.
/// Returns: A boolean value indicating whether the value was successfully saved in the Keychain.
///
/// 2. string(matching identifier: String) -> String?
/// Parameters:
/// identifier: The identifier that was used to save the value in the Keychain.
/// Returns: The value that was saved in the Keychain.
///
/// 3. remove(identifier: String) -> Bool
/// Parameters:
/// identifier: The identifier that was used to save the value in the Keychain.
/// Returns: A boolean value indicating whether the value was successfully removed from the Keychain.
///
/// 4. search(matching cfDictionary: CFDictionary) -> Data?
/// Parameters:
/// cfDictionary: The dictionary to be used to search for the value in the Keychain.
/// Returns: The value that was saved in the Keychain.
///
/// 5. create(cfDictionary: CFDictionary) -> Bool
/// Parameters:
/// cfDictionary: The dictionary to be used to save the value in the Keychain.
/// Returns: A boolean value indicating whether the value was successfully saved in the Keychain.
///
/// 6. update(cfDictionary: CFDictionary) -> Bool
/// Parameters:
/// cfDictionary: The dictionary to be used to update the value in the Keychain.
/// Returns: A boolean value indicating whether the value was successfully updated in the Keychain.
///
/// 7. remove(cfDictionary: CFDictionary) -> Bool
/// Parameters:
/// cfDictionary: The dictionary to be used to remove the value in the Keychain.
/// Returns: A boolean value indicating whether the value was successfully removed from the Keychain.
public class KeychainHelper: KeychainHelperProtocol {
    public static func search(matching cfDictionary: CFDictionary) -> Data? {
        var result: AnyObject?
        let status = SecItemCopyMatching(cfDictionary, &result)
        
        return status == noErr ? result as? Data : nil
        
    }
    public static func create(cfDictionary: CFDictionary) -> Bool {
        let status = SecItemAdd(cfDictionary as CFDictionary, nil)
        
        switch status {
        case errSecSuccess:
            return true
        case errSecDuplicateItem:
            return update(cfDictionary: cfDictionary)
        default:
            return false
        }
    }
    public static func update(cfDictionary: CFDictionary) -> Bool {
        var dictionary: CFDictionary
        var update: CFDictionary
        if let queryDictionary = cfDictionary as? [String: CFTypeRef],
           let keyData = queryDictionary[kSecValueData as String]{
            dictionary = cfDictionary
            update = [secValueData: keyData] as CFDictionary
            let status = SecItemUpdate(dictionary as CFDictionary, update as CFDictionary)
            
            return status == errSecSuccess
        } else {
            return false
        }
    }
    public static func remove(cfDictionary: CFDictionary) -> Bool {
        var dictionary: CFDictionary
        dictionary = cfDictionary
        let status = SecItemDelete(dictionary as CFDictionary)
        return status == errSecSuccess
    }
}


extension KeychainHelper {
    @discardableResult
    public static func remove(identifier: String) -> Bool {
        var dictionary: CFDictionary
        
        dictionary = setupSearchDirectory(for: identifier) as CFDictionary
        let status = SecItemDelete(dictionary as CFDictionary)
        return status == errSecSuccess
        
    }
    
    
    @discardableResult
    public static func create(value: String, forIdentifier identifier: String) -> Bool {
        var dictionary: CFDictionary
        
        var localDictionary = setupSearchDirectory(for: identifier)
        
        let encodedValue = value.data(using: .utf8)
        localDictionary[secValueData] = encodedValue
        
        // Protect the keychain entry so its only valid when the device is unlocked
        localDictionary[secAttrAccessible] = kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly
        dictionary = localDictionary as CFDictionary
        let status = SecItemAdd(dictionary as CFDictionary, nil)
        
        switch status {
        case errSecSuccess:
            return true
        case errSecDuplicateItem:
            return update(value: value, forIdentifier: identifier)
        default:
            return false
        }
    }
    
    public static func string(matching identifier: String) -> String? {
        guard let data = search(matching: identifier) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    private static func search(matching identifier: String) -> Data? {
        var dictionary: CFDictionary
        
        var localDictionary = setupSearchDirectory(for: identifier)
        
        // Limit search results to one
        localDictionary[secMatchLimit] = kSecMatchLimitOne
        
        // Specify we want NSData/CFData returned
        localDictionary[secReturnData] = kCFBooleanTrue
        
        dictionary = localDictionary as CFDictionary
        var result: AnyObject?
        let status = SecItemCopyMatching(dictionary as CFDictionary, &result)
        
        return status == noErr ? result as? Data : nil
        
        
    }
    private static func update(value: String, forIdentifier identifier: String) -> Bool {
        var dictionary: CFDictionary
        var update: CFDictionary
        
        dictionary = setupSearchDirectory(for: identifier) as CFDictionary
        let encodedValue = value.data(using: .utf8)
        update = [secValueData: encodedValue] as CFDictionary
        let status = SecItemUpdate(dictionary as CFDictionary, update as CFDictionary)
        
        return status == errSecSuccess
    }
    private static func setupSearchDirectory(for identifier: String) -> [String: Any] {
        // We are looking for passwords
        var searchDictionary: [String: Any] = [secClass: kSecClassGenericPassword]
        
        // Identify our access
        searchDictionary[secAttrService] = Bundle.main.bundleIdentifier
        
        // Uniquely identify the account who will be accessing the keychain
        let encodedIdentifier = identifier.data(using: .utf8)
        searchDictionary[secAttrGeneric] = encodedIdentifier
        searchDictionary[secAttrAccount] = encodedIdentifier
        
        return searchDictionary
    }
    
}
