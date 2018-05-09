import Utility

// TODO: rename to init-project
// TODO: check if files exist
// TODO: add --force option

class InitCommand: DevopsCommand {
    convenience init() {
        self.init(name: "init", summary: "Initialize the package for managegement")
    }

    override func run(result: ArgumentParser.Result) {
        do {
            let templates = Templates(project: project)

            try shell.writeTextFile(atPath: "Dockerfile", contents: templates.dockerfileContents)
            try shell.writeTextFile(atPath: "Dockerfile-tools", contents: templates.dockerfileToolsContents)
            try shell.writeTextFile(atPath: "devops.md", contents: templates.devopsFileContents)

            try shell.ensureDirectoryExists(atPath: project.chartPath)
            try shell.writeTextFile(atPath: "\(project.chartPath)/Chart.yaml", contents: templates.chartYAMLContents)
            try shell.writeTextFile(atPath: "\(project.chartPath)/values.yaml", contents: templates.valuesYAMLContents)

            try shell.ensureDirectoryExists(atPath: "\(project.chartPath)/charts")

            try shell.ensureDirectoryExists(atPath: "\(project.chartPath)/templates")
            try shell.writeTextFile(atPath: "\(project.chartPath)/templates/deployment.yaml", contents: templates.deploymentYAMLContents)

            if project.license == "MIT" {
                try shell.writeTextFile(atPath: "LICENSE", contents: templates.mitLicenseContents)
            } else {
                try shell.writeTextFile(atPath: "LICENSE", contents: templates.proprietaryLicenseContents)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
