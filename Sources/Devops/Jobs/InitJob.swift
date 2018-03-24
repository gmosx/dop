import Foundation

// TODO: rename to init-project
// TODO: render Dockerfile, help charts, how-to-deploy, etc.
// TODO: check if files exist
// TODO: add --force option
// TODO: emit instructions how-to-deploy, etc.

/// Intialize the package for mangement by `dop`.
public class InitJob: DevopsJob {
    public override func run() {
        do {
            let templates = Templates(project: project)

            try shell.writeTextFile(atPath: "Dockerfile", contents: templates.dockerfileContents)

            try shell.ensureDirectoryExists(atPath: project.chartPath)
            try shell.writeTextFile(atPath: "\(project.chartPath)/Chart.yaml", contents: templates.chartYAMLContents)
            try shell.writeTextFile(atPath: "\(project.chartPath)/values.yaml", contents: templates.valuesYAMLContents)

            try shell.ensureDirectoryExists(atPath: "\(project.chartPath)/charts")

            try shell.ensureDirectoryExists(atPath: "\(project.chartPath)/templates")
            try shell.writeTextFile(atPath: "\(project.chartPath)/templates/deployment.yaml", contents: templates.deploymentYAMLContents)
        } catch {
            print(error.localizedDescription)
        }
    }
}
