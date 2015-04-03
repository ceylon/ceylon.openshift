"This module allows you to check if you are running on openshift and if yes
 to get information about the host/ip you should bind on, your public dns
 and database information."
by("Stephane Epardaud")
module ceylon.openshift "1.1.0" {
    import java.base "7";
    import ceylon.file "1.1.0";
}
