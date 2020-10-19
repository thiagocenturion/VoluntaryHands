//
//  AppEnvironment.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 27/09/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import Foundation
import Network
import FirebaseStorage

struct AppEnvironment {
    
    // MARK: - Public properties
    let counter: LaunchCounter
    let files: FileManager
    let network: NetworkType
    let remoteStorage: Storage
    
    // MARK: - Initialization
    init(counter: LaunchCounter,
         files: FileManager,
         network: NetworkType,
         remoteStorage: Storage) {
        self.counter = counter
        self.files = files
        self.network = network
        self.remoteStorage = remoteStorage
    }
}

extension Storage {
    func saveNewProfilePicture(_ data: Data, childPath: String, completion: @escaping (StorageMetadata, URL) -> ()) -> Void {
        let references = reference().child(childPath)
        
        references.putData(data, metadata: nil) { metadata, error in
            guard let metadata = metadata else {
                print("ERROR IN SAVING IMAGE FIREBASE STORAGE!!")
                print(error?.localizedDescription ?? "")
                return
            }
            
            references.downloadURL { url, error in
                guard let downloadURL = url else {
                    print("ERROR IN GETTING IMAGE URL PROFILE PICTURE FROM FIREBASE STORAGE!!")
                    print(error?.localizedDescription ?? "")
                    return
                }
                
                completion(metadata, downloadURL)
            }
        }
    }
}

#if UNIT_TEST

extension AppEnvironment {
    
    static func mock(counter: LaunchCounter = .init(),
                     files: FileManager = .default,
                     network: NetworkType = Network.mock(),
                     remoteStorage: Storage = Storage.storage()) -> AppEnvironment {
        
        return AppEnvironment(
            counter: counter,
            files: files,
            network: network,
            remoteStorage: remoteStorage
        )
    }
}

#endif
