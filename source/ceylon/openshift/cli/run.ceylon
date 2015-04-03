import ceylon.file {
    Visitor,
    parsePath,
    File,
    Nil,
    createZipFileSystem,
    Directory
}
import java.util {
    EnumSet, JSet = Set
}
import java.nio.file.attribute {
    PosixFilePermission { ... }
}
shared void run() {
    "Usage: ceylon openshift init module/version: command required"
    assert(exists command = process.arguments[0]);
    "Usage: ceylon openshift init module/version: only init command supported"
    assert(command == "init");
    
    variable Boolean force = false;
    variable Boolean aether = false;
    variable String? modSpecOption = null;
    
    // see if we have options
    for(arg in process.arguments.rest){
        switch(arg)
        case("--force"){
            force = true;
        }
        case("--aether"){
            aether = true;
        }
        else{
            modSpecOption = arg;
            break;
        }
    }
    "Usage: ceylon openshift init module/version: module spec required"
    assert(exists modSpec = modSpecOption);
    
    assert(exists res= `module ceylon.openshift`.resourceByPath(".openshift/config/ceylon.properties"));
    Integer start;
    if(exists fileStart = res.uri.firstInclusion("file:")){
        start = fileStart + 5;
    }else if(exists cpStart = res.uri.firstInclusion("classpath:")){
        start = cpStart + 10;
    }else{
        throw AssertionError("Failed to find URI of car: ``res.uri``");
    }
    assert(exists end = res.uri.firstOccurrence('!'));
    value myCar = res.uri.span(start, end-1);
    
    value resourcesPath = "/ceylon/openshift/.openshift/";
    value zipPath = parsePath(myCar);
    if (is Nil|File loc = zipPath.resource) {
        value zipSystem = createZipFileSystem(loc);
        for (rootPath in zipSystem.rootPaths) {
            object visitor
                    extends Visitor() {
                shared actual Boolean beforeDirectory(Directory dir) {
                    if(dir.path.absolutePath.string.startsWith(resourcesPath)){
                        String name = ".openshift/" + dir.path.absolutePath.string.spanFrom(resourcesPath.size);
                        value localPath = parsePath(name);
                        if(is Nil localFile = localPath.resource){
                            localFile.createDirectory();
                        }
                    } 
                    return true;
                }
                void copy(String name, Nil localFile, File f) {
                    if(name == ".openshift/config/ceylon.properties"){
                        value settingsFile = localFile.createFile();
                        try (overwriter = settingsFile.Overwriter()) {
                            overwriter.writeLine("ceylon_module=``modSpec``");
                        }
                        print("Generated");
                    }else{
                        value newFile = f.copy(localFile, true);
                        // zip file does not preserve executable bit, and opensfhit complains if they're not
                        if(name.startsWith(".openshift/action_hooks")){
                            JSet<PosixFilePermission> perms =
                                    EnumSet<PosixFilePermission>.\iof(\iOWNER_READ, \iOWNER_WRITE, \iOWNER_EXECUTE, 
                                \iGROUP_READ, \iGROUP_WRITE, \iGROUP_EXECUTE,
                                \iOTHERS_READ);
                            newFile.writeAttribute(["posix", "permissions"], perms);
                        }
                        print("Copied");
                    }
                }
                
                shared actual void file(File f) {
                    if(f.path.absolutePath.string.startsWith(resourcesPath)){
                        String name = ".openshift/" + f.path.absolutePath.string.spanFrom(resourcesPath.size);
                        process.write("Installing file ``name``: ");
                        value localPath = parsePath(name);
                        if(is Nil localFile = localPath.resource){
                            copy(name, localFile, f);
                        }else if(is File localFile = localPath.resource, force){
                            copy(name, localFile.delete(), f);
                        }else{
                            print("Skipped (already exists)");
                        }
                    } 
                }
            }
            rootPath.visit(visitor);
        }
        zipSystem.close();
        if(aether){
            value name = ".openshift/markers/enable_aether";
            process.write("Installing file ``name``: ");
            value localPath = parsePath(name);
            if(is Nil localFile = localPath.resource){
                value settingsFile = localFile.createFile();
                try (overwriter = settingsFile.Overwriter()) {
                    overwriter.writeLine("");
                    print("Generated");
                }
            }else if(is File localFile = localPath.resource, force){
                try (overwriter = localFile.Overwriter()) {
                    overwriter.writeLine("");
                    print("Generated");
                }
            }else{
                print("Skipped (already exists)");
            }
        }
    }
    
}