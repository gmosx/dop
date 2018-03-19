import Foundation
import Common

public class CleanJob {
    public init() {
    }
    
    public func run() {
        do {
            let shell = Shell()
            
            print("Removing 'Dockerfile'...", terminator: " ")
            try shell.execute(command: "rm Dockerfile")
            print("DONE")

            print("Removing 'deployment.yaml'...", terminator: " ")
            try shell.execute(command: "rm deployment.yaml")
            print("DONE")
        } catch {
            print(error.localizedDescription)
        }
    }
}
