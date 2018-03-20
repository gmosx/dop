import Foundation
import Common

//docker rm -f build-swift
//docker run -it -d --name build-swift -v /Users/gmoschovitis/Code:/Users/gmoschovitis/Code reizu/ubuntu-build-swift /bin/bash
//docker exec -i build-swift bash <<EOF
//cd /Users/gmoschovitis/Code/Fund/FundNotifications
//swift package clean
//swift package update
//swift build --configuration=release
//EOF

/// Builds the production Linux image.
public final class BuildReleaseJob: Job {
    let projectDescriptor: ProjectDescriptor

    public init(projectDescriptor: ProjectDescriptor) {
        self.projectDescriptor = projectDescriptor
    }
    
    func dockerExec(_ command: String) -> String {
        return "docker exec -i build-swift \"\(command)\""
    }

    public func run() {
        let pd = projectDescriptor
        let shell = Shell()

//        docker rm ${name}
//        docker build -t ${namespace}/${name} .

        // TODO: Keep the Dockerfile-tools image in the directory, like idt
        // TODO: try to avoid the hard-coded home paths. -v host-path:container-path
        shell.execute(script: (
            """
            docker rm -f build-swift
            docker run -it -d --name build-swift -v /Users/gmosx/Code:/Users/gmosx/Code reizu/ubuntu-build-swift /bin/bash
            docker exec -i build-swift sh -c "cd /Users/gmosx/Code/\(pd.packagePath) && swift package clean && swift package update && swift build -c release"
            """
        ))

//        let toolsContainerName = "\(pd.name)-tools"
//        shell.execute(script: (
//            """
//            docker rm \(toolsContainerName)
//            docker build -t reizu/\(toolsContainerName) -f Dockerfile.tools .
//            """
//        ))
    }
}
