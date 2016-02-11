# Ceylon module for running on OpenShift.

Contains information about the running instance of OpenShift.

# Usage

To import this module in your Ceylon module descriptor:

```ceylon
import ceylon.openshift "1.2.1";
```

To turn your module `org.foo/2` into an OpenShift application, you can also install the
CLI plugin we ship:

```shell
$ ceylon plugin install ceylon.openshift/1.2.1
```

And then in your application run:

```shell
$ ceylon openshift init org.foo/2
```

This will create the appropriate `.openshift` folder required by the 
[Ceylon OpenShift cartridge](https://github.com/ceylon/openshift-cartridge), and from
there you can start your OpenShift application written in Ceylon.

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
