import Utility

// TODO: rename to init-project
// TODO: check if files exist
// TODO: add --force option

class InitCommand: DevopsCommand {
    convenience init() {
        self.init(name: "init", summary: "Initialize the package for managegement")
    }

    func initExecutable() throws {
        let templates = Templates(project: project)

        try shell.writeTextFile(atPath: "devops.md", contents: templates.executableDevopsFileContents)

        if project.license == "MIT" {
            try shell.writeTextFile(atPath: "LICENSE", contents: templates.mitLicenseContents)
        } else {
            try shell.writeTextFile(atPath: "LICENSE", contents: templates.proprietaryLicenseContents)
        }
    }

    func initLibrary() throws {
        let templates = Templates(project: project)

        try shell.writeTextFile(atPath: "devops.md", contents: templates.libraryDevopsFileContents)

        if project.license == "MIT" {
            try shell.writeTextFile(atPath: "LICENSE", contents: templates.mitLicenseContents)
        } else {
            try shell.writeTextFile(atPath: "LICENSE", contents: templates.proprietaryLicenseContents)
        }
    }

    func initContainer() throws {
        let templates = Templates(project: project)

        try shell.writeTextFile(atPath: "Dockerfile", contents: templates.dockerfileContents)
        try shell.writeTextFile(atPath: "Dockerfile-tools", contents: templates.dockerfileToolsContents)
        try shell.writeTextFile(atPath: "devops.md", contents: templates.containerDevopsFileContents)

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

        print("Please read the `devops.md` file for additional information on dev-ops workflows.")
    }

    override func run(result: ArgumentParser.Result) {
        do {
            switch project.targetType {
            case "executable":
                try initExecutable()

            case "library":
                try initLibrary()

            case "container":
                try initContainer()

            default:
                print("Unknown target type '\(project.targetType)'")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
