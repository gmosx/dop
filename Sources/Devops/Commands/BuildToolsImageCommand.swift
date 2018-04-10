import Utility

class BuildToolsImageCommand: DevopsCommand {
    convenience init() {
        self.init(name: "tools-build-image", summary: "Build the tools image")
    }

    override func run(result: ArgumentParser.Result) {
        do {
            try shell.execute("docker build -f Dockerfile-tools -t \(project.toolsImageName) .")
        } catch {
            print(error.localizedDescription)
        }
    }
}
