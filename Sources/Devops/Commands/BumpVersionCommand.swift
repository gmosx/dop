import Foundation
import Utility

// TODO: consider renaming to updateVersion, support increment/decrement, etc
// TODO: commit after bumping versions, before tagging
// TODO: support bumping for non-container/executable targets

class BumpVersionCommand: DevopsCommand {
    convenience init() {
        self.init(name: "version-bump", summary: "Bump the version")
    }

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

    override func run(result: ArgumentParser.Result) {
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
