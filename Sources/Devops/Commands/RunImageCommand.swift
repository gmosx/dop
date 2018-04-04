import Utility

// TODO: stop docker container on-exit!

class RunImageCommand: DevopsCommand {
    convenience init(project: Project) {
        self.init(name: "image-run", summary: "Run the image as a local container", project: project)
    }

    override func run(result: ArgumentParser.Result) {
        do {
            try shell.execute(script:
                """
                docker rm -f \(project.name)
                docker build -t \(project.fullImageName) .
                docker run -t --name \(project.name) \(project.fullImageName)
                """
            )
        } catch {
            print(error.localizedDescription)
        }
    }
}
