import Foundation
import Common

public final class LoginJob: Job {
    let projectDescriptor: ProjectDescriptor
    
    public init(projectDescriptor: ProjectDescriptor) {
        self.projectDescriptor = projectDescriptor
    }
    
    public func run() {
        let pd = projectDescriptor
//        let shell = Shell()

//        shell.execute(script: (
        print(
            """
            bx login -u \(pd.userName) -p "\(pd.password)" -c \(pd.accountId) -o \(pd.organizationName) -s \(pd.spaceName)
            bx cr login
            bx cs init
            eval `bx cs cluster-config \(pd.clusterName) --export`
            """
//        ))
        )
    }
}

