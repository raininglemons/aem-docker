#!/bin/sh

# dispatcher image config
repo=adobe
image=aem-ethos/dispatcher-publish

echo "1/7 - Moving AEM jar"
unzip -o aem-sdk-2*.zip
aemjar=`ls ./aem-sdk-quickstart*.jar | head -1`
aemzip=`ls ./aem-sdk-2*.zip | head -1`
aemversion=`echo $aemzip | cut -d'-' -f3`
dispatcherinstaller=`ls ./aem-sdk-dispatcher-tools-*-unix.sh | head -1`
dispatcherimageversion=`echo $dispatcherinstaller | cut -d'-' -f5`
dispatcherimageurl="${repo}/${image}:${dispatcherimageversion}"

if [[ $(uname -p) == 'arm' ]]; then
  cputype=arm64
else
  cputype=amd64
fi

mv $aemjar "./aem-base-image/cq-quickstart.jar"

# Install dispatcher tools image if necessary
echo "2/7 - Loading (if required) dispatcher docker image"
echo "Required image not found, trying to load from archive..."
chmod u+x $dispatcherinstaller
cp $dispatcherinstaller aem-dispatcher/dispatcher/installer.sh
if [ -z "$(docker images -q "${dispatcherimageurl}" 2> /dev/null)" ]; then
    eval $dispatcherinstaller
    file=$(pwd)/dispatcher-sdk-${dispatcherimageversion}/lib/dispatcher-publish-${cputype}.tar.gz
    [ -f "${file}" ] || error "unable to find archive at expected location: $file"
    gunzip -c "${file}" | docker load
    # Tag as latest so we don't need to keep updating our Dockerfile for aem-dispatcher when we change aem version
    docker tag ${dispatcherimageurl} ${repo}/${image}:latest
    [ -n "$(docker images -q "${dispatcherimageurl}" 2> /dev/null)" ] || error "required image still not found: $dispatcherimageurl"
fi

# Finally build local images
echo "3/7 - Building aem-base-image"
docker build -t aem-base-image:latest -t aem-base-image:${aemversion} ./aem-base-image

echo "4/7 - Building aem-author"
docker build -t aem-author:latest -t aem-author:${aemversion} ./aem-author

echo "5/7 - Building aem-publish"
docker build -t aem-publish:latest -t aem-publish:${aemversion} ./aem-publish

echo "6/7 - Building aem-dispatcher"
docker build -t aem-dispatcher:latest -t aem-dispatcher:${dispatcherimageversion} ./aem-dispatcher

echo "7/7 - Building aem-nginx"
docker build -t aem-nginx:latest -t aem-nginx:${aemversion} ./aem-nginx

# clean up
rm ./aem-sdk-dispatcher*.sh
rm ./aem-sdk-dispatcher*.zip
rm -rf ./dispatcher-sdk-*
rm -r ./aem-dispatcher/dispatcher/installer.sh
rm ./aem-base-image/cq-quickstart.jar