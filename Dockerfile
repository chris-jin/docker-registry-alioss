# This file describes how to build a docker-registry supports aliyun oss as the storage
# AUTHOR: Chris Jin <chrisjin@outlook.com>
# TO_BUILD:       docker build -rm -t registry .
# TO_RUN:         docker run -e OSS_BUCKET=<oss_bucket>  -e STORAGE_PATH=/docker/ -e OSS_KEY=<oss_key>  -e OSS_SECRET=<oss_secret>  -p 5000:5000 registry

AUTHOR: Chris Jin <chrisjin@outlook.com>
FROM	registry:0.8.1

# Packaged dependencies
RUN	apt-get update && apt-get install -y wget unzip 

#get ali-oss api 
RUN mkdir -p /ali_oss/api && cd /ali_oss/api \
        && wget http://aliyunecs.oss-cn-hangzhou.aliyuncs.com/OSS_Python_API_20140509.zip \
        && unzip OSS_Python_API_20140509.zip && sudo python setup.py install

#get docker-registry-driver-alioss
RUN cd /ali_oss \
        && wget -r -np -nd --no-check-certificate https://github.com/chris-jin/docker-registry-driver-alioss/archive/master.zip \
        && unzip master.zip && cd  docker-registry-driver-alioss-master/  && sudo python setup.py install

#clear
RUN \rm -rf /ali_oss

#add ali oss config to the config.yml
RUN \cp -f /docker-registry/config/config_sample.yml /docker-registry/config/config.yml
RUN echo 'oss: &oss' >> /docker-registry/config/config.yml
RUN echo '    <<: *common' >> /docker-registry/config/config.yml
RUN echo '    storage: alioss' >> /docker-registry/config/config.yml
RUN echo '    storage_path: _env:STORAGE_PATH:/devregistry/' >> /docker-registry/config/config.yml
RUN echo '    oss_bucket: _env:OSS_BUCKET' >> /docker-registry/config/config.yml
RUN echo '    oss_accessid: _env:OSS_KEY' >> /docker-registry/config/config.yml
RUN echo '    oss_accesskey: _env:OSS_SECRET' >> /docker-registry/config/config.yml

#set env
env DOCKER_REGISTRY_CONFIG /docker-registry/config/config.yml
env SETTINGS_FLAVOR oss
RUN unset SEARCH_BACKEND  

cmd exec docker-registry
