//
//  UCHandlingJSON.swift
//  CloseCareFramework
//
//  Created by Luke Wolfram on 9/23/24.
//

import Foundation

//Do not use error.localized description it is so ass
//Instead just do error and you'll get way more details

func readLocalJSONFile(forName name: String) -> Data? {
    do {
        if let filePath = Bundle.main.path(forResource: name, ofType: "json") {
            let fileUrl = URL(filePath: filePath, directoryHint: .notDirectory)
            let data = try Data(contentsOf: fileUrl)
            return data
        } else {
            print("File not found in bundle")
        }
    } catch {
        print("error: \(error)")
    }
    return nil
}
           
func decodeJSON<T: Decodable>(from data: Data, as type: T.Type) -> T? {
    do {
        let decodedData = try JSONDecoder().decode(T.self, from: data)
        return decodedData
    } catch {
        print("Failed to decode JSON: \(error)")
        return nil
    }
    
}

