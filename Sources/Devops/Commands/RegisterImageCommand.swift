import Utility

// TODO: consider renaming to RegisterImageCommand (image-register)
// TODO: introduce UnregisterImageCommand (image-unregister <tag>)

class RegisterImageCommand: DevopsCommand {
    convenience init() {
        self.init(name: "image-register", summary: "Push the image to the registry")
    }

    override func run(result: ArgumentParser.Result) {
        do {
            try shell.execute("docker push \(project.fullImageName)")
        } catch {
            print(error.localizedDescription)
        }
    }
}

