import Foundation
import Basic
import Utility

// TODO: Rename to ShellClient, ShellDriver or ShellUtils?
// TODO: Extract to other package.
// TODO: support streaming output.
// TODO: verbose option.

extension String {
    func escapingForShell() -> String {
        return self
            .replacingOccurrences(of: "&", with: "\\&")
            .replacingOccurrences(of: "!", with: "\\!")
    }
}

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
    
    public func ensureDirectoryExists(atPath path: String) throws {
        let fm = FileManager.default

        if !fm.fileExists(atPath: path) {
            print("Created \(path)")
            try fm.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    // TODO: allow override/not-override
    public func writeTextFile(atPath path: String, contents: String) throws {
        try contents.write(to: URL(fileURLWithPath: path), atomically: false, encoding: .utf8)
        print("Created \(path)")
    }
    
    public func removeFile(atPath path: String) throws {
        try FileManager.default.removeItem(atPath: path)
        print("Removed \(path)")
    }

    public func removeDirectory(atPath path: String) throws {
        try FileManager.default.removeItem(atPath: path)
        print("Removed \(path)")
    }
}
