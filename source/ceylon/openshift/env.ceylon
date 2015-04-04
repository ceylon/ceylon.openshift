import java.lang {
    System
}
String require(String name){
    assert(exists val = System.getenv(name));
    return val;
}

Integer requireInteger(String name){
    value p = require(name);
    assert(exists parsed = parseInteger(p));
    return parsed;
}
