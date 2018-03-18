import Foundation

// TODO: Extract to other package.
// TODO: Don't use deprecated methods

public class Shell {
    public init() {
    }
    
    @discardableResult
    public func execute(command: String) -> String? {
        let process = Process()
        process.launchPath = "/bin/bash"
        process.arguments = ["-c", command]
        
        let pipe = Pipe()
        process.standardOutput = pipe
        process.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    public func execute(script: String) {
        for scriptCommand in script.split(separator: "\n") {
            if let output = execute(command: String(scriptCommand)) {
                print(output, terminator: "")
            }
        }
    }
}
