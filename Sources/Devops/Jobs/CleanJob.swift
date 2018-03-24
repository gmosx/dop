import Foundation
import Common

public class CleanJob: DevopsJob {
    public override func run() {
        do {
            if shell.confirm("Are you sure you want to delete all generated files?") {
                try shell.removeFile(atPath: "Dockerfile")
                try shell.removeDirectory(atPath: "chart")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
