
//
//  ServerTrackerAPI.swift
//  ServerFullnessChecker
//
//  Created by Jing Wei Li on 5/1/20.
//  Copyright © 2020 Jing Wei Li. All rights reserved.
//

import Foundation
import Alamofire
import Combine

class ServerTrackerAPI {
    static let apiRoot = "https://api.jingweili.me/api/"
    
    // MARK: - Device IDs
    
    class func IdExistsForDeviceID(_ id: String) -> Future<ServerResponse, Error> {
        return postIDForServerResponse(on: id, apiPath: "is_device_duplicated")
    }
    
    class func addDeviceID(_ id: String) -> Future<ServerResponse, Error> {
       return postIDForServerResponse(on: id, apiPath: "add_device_id")
    }
    
    private class func postIDForServerResponse(on id: String, apiPath: String) -> Future<ServerResponse, Error> {
        return Future { promise in
            let headers = [HTTPHeader(name: "Content-Type", value: "application/json")]
            AF.request(
                "\(apiRoot)\(apiPath)",
                method: .post,
                parameters: ["id": id],
                encoding: JSONEncoding.default,
                headers: HTTPHeaders(headers)).responseJSON
            { json in
                if let data = json.data {
                    do {
                        let resp = try JSONDecoder().decode(ServerResponse.self, from: data)
                        promise(.success(resp))
                    } catch let err {
                        promise(.failure(err))
                    }
                } else if let error = json.error {
                    promise(.failure(error))
                }
            }
        }
    }
    
    // MARK: - Register Servers
    class func serverExistsForId(_ server: BattlefieldServer) -> Future<ServerResponse, Error> {
        return postServerData(on: server, apiPath: "is_server_duplicated")
    }
    
    class func addServerWithId(_ server: BattlefieldServer) -> Future<ServerResponse, Error> {
       return postServerData(on: server, apiPath: "add_server")
    }
    
    private class func postServerData(on server: BattlefieldServer, apiPath: String) -> Future<ServerResponse, Error> {
        return Future { promise in
            let headers = [HTTPHeader(name: "Content-Type", value: "application/json")]
            AF.request(
                "\(apiRoot)\(apiPath)",
                method: .post,
                parameters: ["id": server.id, "name": server.name, "game": server.game],
                encoding: JSONEncoding.default,
                headers: HTTPHeaders(headers)).responseJSON
            { json in
                if let data = json.data {
                    do {
                        let resp = try JSONDecoder().decode(ServerResponse.self, from: data)
                        promise(.success(resp))
                    } catch let err {
                        promise(.failure(err))
                    }
                } else if let error = json.error {
                    promise(.failure(error))
                }
            }
        }
    }
    
    // MARK: - Servers Interaction
    class func muteNotifications() -> Future<ServerResponse, Error> {
        return AF.requestTyped(endpoint: "\(apiRoot)mute", method: .get, parameters: nil, headers: ["Content-Type": "application/json"])
    }
    
    class func unmuteNotifications() -> Future<ServerResponse, Error> {
        return AF.requestTyped(endpoint: "\(apiRoot)unmute", method: .get, parameters: nil, headers: ["Content-Type": "application/json"])
    }
    
    class func isNotificationsMuted() -> Future<MutedResponse, Error> {
        return AF.requestTyped(endpoint: "\(apiRoot)is_muted", method: .get, parameters: nil, headers: ["Content-Type": "application/json"])
    }
    
    class func getServers() -> Future<[BattlefieldServer], Error> {
        return AF.requestTyped(endpoint: "\(apiRoot)get_servers", method: .get, parameters: nil, headers: ["Content-Type": "application/json"])
    }
    
    // MARK: - Server Details
    class func getDetailForServerWithId(_ id: String, game: String) -> Future<BattlelogServer, Error> {
        return AF.requestTyped(
            endpoint: "https://battlelog.battlefield.com/\(game)/servers/show/pc/\(id)",
            method: .get,
            parameters: nil,
            headers: ["Content-Type": "application/json"])
        { data in
            if let string = String(data: data, encoding: .utf8) {
                let pattern1 = "surface_7_6.render(.*)Surface.logMissingBlockConfig"
                let regex = try NSRegularExpression(pattern: pattern1)
                let range = NSRange(string.startIndex..<string.endIndex, in: string)
                if let match = regex.firstMatch(in: string, options: [], range: range), let range = Range(match.range, in: string) {
                    let json = String(string[range])
                        .replacingOccurrences(of: "surface_7_6.render(", with: "")
                        .replacingOccurrences(of: "Surface.logMissingBlockConfig", with: "")
                        .replacingOccurrences(of: ", block_serverguide_bf3show) : ", with: "")
                    return json.data(using: .utf8)
                }
            }
            return nil
        }
    }
    
    class func getPlayersOnServer(_ server: BattlefieldServer) -> Future<BattlelogPlayer, Error> {
        return AF.requestTyped(
            endpoint: "https://battlelog.battlefield.com/\(server.game)/servers/getPlayersOnServer/pc/\(server.id)/",
            method: .get, parameters: nil, headers: ["Content-Type": "application/json"])
    }

            
}
