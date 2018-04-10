import Utility

class PushImageCommand: DevopsCommand {
    convenience init() {
        self.init(name: "image-push", summary: "Push the image to the registry")
    }

    override func run(result: ArgumentParser.Result) {
        do {
            try shell.execute("docker push \(project.fullImageName)")
        } catch {
            print(error.localizedDescription)
        }
    }
}
