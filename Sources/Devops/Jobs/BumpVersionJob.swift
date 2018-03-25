import Foundation
import Utility

// TODO: consider renaming to updateVersion, support increment/decrement, etc

/// Increment the version number to a new, unique value.
public final class BumpVersionJob: DevopsJob {
    public func updateDopfile() throws {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        let jsonData = try jsonEncoder.encode(project.descriptor)

        if let dopfileContents = String(data: jsonData, encoding: .utf8) {
            try shell.writeTextFile(atPath: "dop.json", contents: dopfileContents)
        }
    }

    public func writeUpdatedHelmFiles() throws {
        let templates = Templates(project: project)

        try shell.writeTextFile(atPath: "\(project.chartPath)/Chart.yaml", contents: templates.chartYAMLContents)
        try shell.writeTextFile(atPath: "\(project.chartPath)/values.yaml", contents: templates.valuesYAMLContents)
    }

    // TODO: consider tagging only on image-push
    public func tagGitRepo() throws {
        try shell.execute("git tag \(project.version)")
    }

    public override func run() {
        do {
            project.bumpVersion()

            print("Bumped version to \(project.version)")

            try updateDopfile()
            try writeUpdatedHelmFiles()
            try tagGitRepo()
        } catch {
            print(error.localizedDescription)
        }
    }
}
