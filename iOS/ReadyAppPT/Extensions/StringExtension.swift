/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2014. All Rights Reserved.
This sample program is provided AS IS and may be used, executed, copied and modified without royalty payment by customer
(a) for its own instruction and study, (b) in order to develop applications designed to run with an IBM product,
either for customer's own internal use or for redistribution by customer, as part of such an application, in customer's
own products.
*/

import Foundation

/**
*  String extension used for login data security.
*/
extension String {
    
    /**
    Method that encrypts key and converts it to a base64 string
    
    :param: key value to encrypt for secure data transfer
    
    :returns: base64 string of encrypted key
    */
    func encrypt(key: String) -> String {
        var data =  self.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) as NSData!
        var encryptedData = MyCrypt.encryptData(data, password: key, error: nil)
        let base64cryptString = encryptedData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.allZeros)
        return base64cryptString
    }
    
    /**
    Method that decodes key from base64 and decrypts into a string
    
    :param: key value to decode and decrypt
    
    :returns: string of decrypted data
    */
    func decrypt(key: String!) -> String {
        let data = NSData(base64EncodedString: self, options: NSDataBase64DecodingOptions.allZeros)
        var error : NSError! = NSError()
        let decryptedData = RNDecryptor.decryptData(data, withPassword: key, error: nil)
        let base64decryptString = MyCrypt.stringFromData(decryptedData)
        return base64decryptString
    }
}

/**
*  Double extension simply for formatting doubles into printable strings.
*/
extension Double {
    func format(f: String) -> String {
        return NSString(format: "%\(f)f", self)
    }
}