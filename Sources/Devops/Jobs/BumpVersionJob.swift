import Foundation
import Utility

// TODO: consider renaming to updateVersion, support increment/decrement, etc
// TODO: should update helm values.yaml, Chart.yaml

/// Increment the version number to a new, unique value.
public final class BumpVersionJob: DevopsJob {
    public func tagGitRepo() {
        let shell = Shell()

        shell.execute(script: (
            """
            git tag \(project.version)
            """
        ))

        print("Tagged git repo: \(project.version)")
    }

    public override func run() {
        do {
            project.bumpVersion()

            print("New version: \(project.version)")
            
            let jsonEncoder = JSONEncoder()
            jsonEncoder.outputFormatting = .prettyPrinted
            let jsonData = try jsonEncoder.encode(project.descriptor)
            if let dopfileContents = String(data: jsonData, encoding: .utf8) {
                print("Updating 'dop.json'...", terminator: " ")
                try dopfileContents.write(to: URL(fileURLWithPath: "dop.json"), atomically: false, encoding: .utf8)
                print("DONE")
            }

            tagGitRepo()
        } catch {
            print(error.localizedDescription)
        }
    }
}
