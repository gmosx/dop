import Foundation
import Common

// TODO: Ask confirmation!

public class CleanJob {
    public init() {
    }
    
    public func run() {
        do {
            let shell = Shell()
            
            try shell.removeFile(atPath: "Dockerfile")
            try shell.removeDirectory(atPath: "chart")
        } catch {
            print(error.localizedDescription)
        }
    }
}
