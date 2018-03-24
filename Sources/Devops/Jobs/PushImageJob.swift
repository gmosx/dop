import Foundation

/// Push the release image to the registry
public final class PushImageJob: DevopsJob {
    public override func run() {
        do {
            try shell.execute("docker push \(project.fullImageName)")
        } catch {
            print(error.localizedDescription)
        }
    }
}
