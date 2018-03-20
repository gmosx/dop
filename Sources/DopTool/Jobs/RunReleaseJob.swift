import Foundation
import Common

/// Runs the production Linux image.
public final class RunReleaseJob: Job {
    let projectDescriptor: ProjectDescriptor

    public init(projectDescriptor: ProjectDescriptor) {
        self.projectDescriptor = projectDescriptor
    }

    public func run() {
        let pd = projectDescriptor
        let shell = Shell()

        let namespace = "reizu"
        let imageName = "\(namespace)/\(pd.name)"

        shell.execute(script: (
            """
            docker rm -f \(pd.name)
            docker build -t \(imageName) .
            docker run -t --name \(pd.name) \(imageName)
            """
        ))
    }
}
