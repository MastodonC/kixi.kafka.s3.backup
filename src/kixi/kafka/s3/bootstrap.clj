(ns kixi.kafka.s3.bootstrap
  (:require [kixi.kafka.s3.core :as k]
            [taoensso.timbre :as log])
  (:gen-class))

(defn -main [& args]
  (log/info "Starting Kafka Stream Backup")
  (.start (k/start-stream)))
