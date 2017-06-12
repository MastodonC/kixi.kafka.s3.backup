package kixi.kafka.s3;

import clojure.java.api.Clojure;
import clojure.lang.IFn;

/**
 * We've had a lot of problems with aot. This bootstraps our clojure code from java avoiding that completely.
 */
class JavaBootstrap {

    public static void main(String[] args) {

        IFn require = Clojure.var("clojure.core", "require");
        require.invoke(Clojure.read("kixi.kafka.s3.bootstrap"));

        IFn bootstrap = Clojure.var("kixi.kafka.s3.bootstrap", "bootstrap");
        bootstrap.invoke(args);
    }
}
