"This module allows you to check if you are running on openshift and if yes
 to get information about the host/ip you should bind on, your public dns
 and database information.
 
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
 
 If you want to use the CLI plugin to turn your application into an OpenShift
 application running on the Ceylon cartridge.
 
 Now you just have to add the required OpenShift setup to your application, for which
 you can install the `ceylon openshift` command (only need to do this once):
 
     $ ceylon plugin install ceylon.openshift/1.1.1
 
 And now you just turn your Ceylon application into a Ceylon OpenShift application:
 
     $ ceylon openshift init your.main.module/1.0
 
 This will create the necessary setup files in the `.openshift` directory as described 
 [in the Ceylon cartridge help](https://github.com/ceylon/openshift-cartridge/blob/master/template/README.md).
 
 Now you're ready to start, so just push your code somewhere over git and create your
 OpenShift application with the Ceylon cartridge:

     $ rhc create-app --from-code <your-git-url> ceylonapp https://raw.github.com/ceylon/openshift-cartridge/master/metadata/manifest.yml
 "
by("Stephane Epardaud")
module ceylon.openshift "1.1.1" {
    import java.base "7";
    import ceylon.file "1.1.0";
}
