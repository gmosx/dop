import Foundation

// TODO: escape password for bash &, ! -> \&, \! (in Shell, extract)

public final class LoginJob: BaseToolJob {
    public override func run() {
//        let shell = Shell()

//        shell.execute(script: (
        print(
            """
            bx login -u \(project.userName) -p "\(project.password)" -c \(project.accountId) -o \(project.organizationName) -s \(project.spaceName)
            bx cr login
            bx cs init
            eval `bx cs cluster-config \(project.clusterName) --export`
            """
//        ))
        )
    }
}

