(ns kixi.kafka.s3.shared
  (:require [taoensso.timbre :as log]
            [clojure.data.csv :as csv]
            [clojure.java.io :as io]
            [environ.core :refer [env]]
            [clj-time.core :as t]
            [clj-time.format :as f])
  (:use [amazonica.aws.s3])
  (:import [java.io PrintWriter InputStreamReader ByteArrayInputStream ByteArrayOutputStream InputStream]
           [java.util.zip GZIPInputStream GZIPOutputStream]))

(def date-format (f/formatters :basic-date))

(defn deserialize-message [bytes]
  (try (-> bytes
           ByteArrayInputStream.
           GZIPInputStream.
           io/reader
           slurp)
       (catch Exception e (log/info (.printStackTrace e)))
       (finally (log/info ""))))

(def gzip-serializer-fn
  (fn [vs]
    (let [output-str (apply str vs)
          out (java.io.ByteArrayOutputStream.)]
      (do (doto (java.io.BufferedOutputStream.
                 (java.util.zip.GZIPOutputStream. out))
            (.write (.getBytes output-str))
            (.close)))
      (.toByteArray out))))

(defn key-name-function [transform-type]
  (str "raw-data-backup" transform-type "/" (f/unparse date-format (t/now)) "/" (f/unparse (f/formatters :hour) (t/now)) "/" (.toString (java.util.UUID/randomUUID)) ".gz"))

(defn upload-file-to-s3 [file-content transform-type]
  (put-object :bucket-name (env :s3-bucket)
              :key (key-name-function transform-type)
              :input-stream (java.io.ByteArrayInputStream. file-content)))
