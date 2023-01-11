//
//  UserDefault+Extension.swift
//  DeviceManager
//
//  Created by Rin on 2023/01/08.
//

import Foundation

extension UserDefaults {

    enum StructDataError: Error {
        case encodeError
        case noDataError
        case decodeError
    }

    func set<T: Encodable>(struct data: T, key: String) throws {
        do {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            let data = try encoder.encode(data)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            throw StructDataError.encodeError
        }
    }

    func structData(key: String) throws -> [DeviceDataEntity] {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let data = UserDefaults.standard.data(forKey: key) else {
                throw StructDataError.noDataError
            }
            print(data)

           // let decodedData = try decoder.decode([DeviceDataEntity].self, from: data)
            return []
        } catch {
            throw StructDataError.decodeError
        }
    }

    static func removeAll() {
        let appDomain = Bundle.main.bundleIdentifier
        UserDefaults.standard.removePersistentDomain(forName: appDomain!)
    }
}
