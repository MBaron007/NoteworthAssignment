//
//  Dictionary+Additions.swift
//  NoteworthAssignment
//
//  Created by Matthew Baron on 7/1/17.
//  Copyright © 2017 Matt Baron. All rights reserved.
//

import Foundation

extension Dictionary {
    
    /// Build string representation of HTTP parameter dictionary of keys and objects
    ///
    /// This percent escapes in compliance with RFC 3986
    ///
    /// http://www.ietf.org/rfc/rfc3986.txt
    ///
    /// :returns: String representation in the form of key1=value1&key2=value2 where the keys and values are percent escaped
    
    func stringFromHttpParameters() -> String {
        let parameterArray = self.map { (key, value) -> String in
            if let stringKey = key as? String, let escapedKey = stringKey.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let stringValue = value as? String, let escapedValue = stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                return "\(escapedKey)=\(escapedValue)"
            }
            
            return ""
        }
        
        return parameterArray.joined(separator: "&")
    }
    
}
