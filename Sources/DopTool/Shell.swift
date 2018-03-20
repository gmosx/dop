import Foundation
import Basic
import Utility

// TODO: Extract to other package.

//docker rm -f build-swift
//docker run -it -d --name build-swift -v /Users/gmoschovitis/Code:/Users/gmoschovitis/Code reizu/ubuntu-build-swift /bin/bash
//docker exec -i build-swift bash <<EOF
//cd /Users/gmoschovitis/Code/Fund/FundNotifications
//swift package clean
//swift package update
//swift build --configuration=release
//EOF

public class Shell {
    public init() {
    }
    
    @discardableResult
    public func execute(command: String) throws -> ProcessResult {
        // https://github.com/apple/swift-package-manager/blob/master/Sources/Basic/Process.swift
        let process = Process(arguments: ["sh", "-c", command])
        try process.launch()
        let result = try process.waitUntilExit()
        return result
    }
    
    public func execute(script: String) {
        do {
            for scriptCommand in script.split(separator: "\n") {
                print("\(scriptCommand)")
                let result = try execute(command: String(scriptCommand))
                print((try? result.utf8Output()) ?? "-")

                switch result.exitStatus {
                case .terminated(let status):
                    if status != 0 {
                        print((try? result.utf8stderrOutput()) ?? "-")
                        break
                    }

                default:
                    continue
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
