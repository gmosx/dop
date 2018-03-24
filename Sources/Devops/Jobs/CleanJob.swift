import Foundation
import Common

// TODO: Ask confirmation!

public class CleanJob: DevopsJob {
    public override func run() {
        do {
            try shell.removeFile(atPath: "Dockerfile")
            try shell.removeDirectory(atPath: "chart")
        } catch {
            print(error.localizedDescription)
        }
    }
}
