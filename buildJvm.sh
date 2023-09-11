#!/usr/bin/env bash

echo "Executing maven build and create custom JVM"

echo "################## Maven ##################"
mvn clean package

echo "################## Lookup Java dependency ##################"
if [ ! -d "target/dependency" ]; then
  echo "Maven dependencies not in 'target/dependency'. Check usage of 'maven-dependency-plugin'!"
  return 1
fi
jdeps --ignore-missing-deps -q --recursive --multi-release 17 --print-module-deps --class-path 'target/dependency/*' target/*.jar > target/deps.info

echo "################## Create JVM from dependency ##################"
jlink  --add-modules $(cat target/deps.info) --strip-debug --compress 2 --no-header-files --no-man-pages --output target/jvm

echo "JVM created in target/jvm:"
target/jvm/bin/java --version