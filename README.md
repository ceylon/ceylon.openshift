# Ceylon module for running on OpenShift.

Contains information about the running instance of OpenShift.

# Example

```ceylon
shared void run() {
    if(openshift.running){
        String url = openshift.postgres.jdbcUrl;
        print("Connecting to postgres at ``url``");
        setupDatabase(url, openshift.postgres.user, openshift.postgres.password, `package fr.devoxx2015.model`);
    }else{
        setupDatabase("jdbc:postgresql://localhost/devoxx2015", 
            "devoxx2015", "devoxx2015", `package fr.devoxx2015.model`);
    }
    Config conf;
    if(openshift.running){
        conf = Config{
            hostName = openshift.ip; 
            port = openshift.port;
            externalHostName = openshift.dns; 
            externalPort = 80;
            applicationPath = openshift.repository;
        };
    }else{
        conf = Config{port = 9001;};
    }
    Application(`package fr.devoxx2015.controller`, conf).start();
}
```
