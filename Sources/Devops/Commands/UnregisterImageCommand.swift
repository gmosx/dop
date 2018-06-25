import Utility

// TODO: this is a dangerous command, ask for confirmation!

class UnregisterImageCommand: DevopsCommand {
    var tagPositional: PositionalArgument<String>!

    convenience init() {
        self.init(name: "image-unregister", summary: "Remove the tagged image from the registry")
    }

    override func setup() {
        tagPositional = argumentParser.add(positional: "tag", kind: String.self, usage: "The tag of the image to unregister")
    }

    override func run(result: ArgumentParser.Result) {
        if let tag = result.get(tagPositional) {
            let fullImageNameToRemove = "\(project.registry)/\(project.imageName):\(tag)"
            let removeCommand = "bx cr image-rm \(fullImageNameToRemove)"

            if tag == project.version {
                print("Cannot automatically unregister the image with the current tag, remove manually if needed:")
                print(removeCommand)
            } else {
                if shell.confirm("Are you sure you want to delete \(fullImageNameToRemove)") {
                    do {
                        try shell.execute(removeCommand)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}
