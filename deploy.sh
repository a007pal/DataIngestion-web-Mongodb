#!/bin/bash
set -euo pipefail
#log fuinctions
log() {
  # Print log message in green
  echo -e "\033[32m[$(date '+%Y-%m-%d %H:%M:%S')] $1\033[0m"
}
log_error() {
  # Print error message in red and print the full deploy.log
  echo -e "\033[31m[$(date '+%Y-%m-%d %H:%M:%S')] $1\033[0m"
  if [ -f ../deploy.log ]; then
    echo -e "\033[31m--- Full deploy.log ---\033[0m"
    cat ../deploy.log
    echo -e "\033[31m--- End of log ---\033[0m"
  elif [ -f deploy.log ]; then
    echo -e "\033[31m--- Full deploy.log ---\033[0m"
    cat deploy.log
    echo -e "\033[31m--- End of log ---\033[0m"
  fi
}

# start building the property-view-taracker lambda
log "Starting to build the property-view-tracker lambda"
log "Starting gradle clean"
cd property-view-tracker
log "Current directory after build: $(pwd)"
./gradlew clean 2>> ../deploy.log || log_error "Gradle clean failed. See deploy.log for details."
log "Gradle clean completed......"
log "Starting gradle build..."
./gradlew buildNativeLambda 2>> ../deploy.log || log_error "Gradle build failed. See deploy.log for details."
log "Build completed successfully for property-view-tracker lambda"
cd ..
log "Current directory after build: $(pwd)"
if [ ! -d build_output ]; then
  log "Directory build_output does not exist. Creating it."
  mkdir build_output
else
  log "Directory build_output already exists.Cleaning the build_output directory....."
  rm -rf build_output/*
  log "Build output directory cleaned"
fi
log "Copying the build output to the build_output directory"
cp property-view-tracker/build/libs/property-view-tracker-0.1-lambda.zip build_output/lambda.zip 2>> deploy.log || log_error "Copy failed. See deploy.log for details."
log "Build output copied to build_output directory as lambda.zip"