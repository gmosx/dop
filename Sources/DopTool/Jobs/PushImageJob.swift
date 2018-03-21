import Foundation
import Common

/// Push the release image to the registry
public final class PushImageJob: Job {
    let projectDescriptor: ProjectDescriptor
    
    public init(projectDescriptor: ProjectDescriptor) {
        self.projectDescriptor = projectDescriptor
    }
    
    public func run() {
        let pd = projectDescriptor
        let shell = Shell()

        let fullImageName = "\(pd.registry)/\(pd.imageName):\(pd.version)"

        shell.execute(script: (
            """
            git tag \(pd.version)
            docker build -t \(fullImageName) .
            docker push \(fullImageName)
            """
        ))
    }
}
