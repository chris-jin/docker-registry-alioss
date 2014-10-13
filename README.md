docker-registry-alioss
======================

dockerfile to create a docker image which uses ali oss as its storage

Usage
=========

Assuming you have docker installed on your machine:

    docker build --rm=true -t registry:ali_oss . #to build the image from this dockerfile
    docker run -e OSS_BUCKET=<your_ali_oss_bucket>  -e STORAGE_PATH=/docker/ -e OSS_KEY=<your_ali_oss_key>  -e OSS_SECRET=<your_ali_oss_secret> -p 5000:5000 -d registry:ali_oss

NOTE: it may be slow for the first time since docker need to get its dependencies from docker-hub.
