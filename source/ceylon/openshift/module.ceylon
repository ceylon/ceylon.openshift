"This module allows you to check if the process is executing
 OpenShift and, if so, to obtain information about the 
 host IP and port you should bind on, your public DNS, and 
 database connection information.
 
 # Usage
 
     void connectToDb(String jdbcUrl, String user, String password){
         // ...
     }
    
     void startHttpServer(String ip, Integer port){
         // ...
     }
     
     shared void run(){
         if(openshift.running){
             if(openshift.ceylon.running){
                 startHttpServer(openshift.ceylon.ip, openshift.ceylon.port);
         }else if(openshift.vertx.running){
             startHttpServer(openshift.vertx.ip, openshift.vertx.port);
         }else{
             // other cartridge?
         }
         if(openshift.postgres.running){
             connectToDb(openshift.postgres.jdbcUrl, openshift.postgres.user, openshift.postgres.password);
         }else if(openshift.mysql.running){
             connectToDb(openshift.mysql.jdbcUrl, openshift.mysql.user, openshift.mysql.password);
         }else{
             // other db?
         }
       }
     }
 
 # CLI plugin usage
 
 The CLI plugin will convert your application into an 
 OpenShift application running on the Ceylon cartridge.
 
 First, install the `ceylon openshift` command (you only 
 need to do this once):
 
     ceylon plugin install ceylon.openshift/1.2.1
 
 Then to convert your Ceylon application into a Ceylon 
 OpenShift application:
 
     ceylon openshift init your.main.module/1.0
 
 This will create the necessary setup files in the 
 `.openshift` directory of your project, as described in the 
 [Ceylon cartridge help][cartridge].
 
 [cartridge]: https://github.com/ceylon/openshift-cartridge/blob/master/template/README.md
 
 Now you're ready to start, so just publish your project to
 a Git repository, and create your OpenShift application 
 with the Ceylon cartridge, using the `rhc` tool:

     rhc create-app --from-code <your-git-url> ceylonapp https://raw.github.com/ceylon/openshift-cartridge/master/metadata/manifest.yml
 "
by("Stephane Epardaud")
native("jvm")
module ceylon.openshift "1.2.1" {
    import java.base "7";
    import ceylon.file "1.2.1";
}
