#!/bin/bash
#

DIR="/opt/aem/crx-quickstart/repository"

if [ -d "$DIR" ] && [ "$(ls -A $DIR)" ]
then
  echo "Repository already initialised, not installing packages."
  rm -r crx-quickstart/install
else
  echo "$DIR is empty, allowing install packages to be installed and jar to unpack."
  cp -r packages crx-quickstart/install
fi

# reference: https://unix.stackexchange.com/questions/146756/forward-sigterm-to-child-in-bash
# work around to ensure we pass on exit commands to aem
prep_term()
{
    unset term_child_pid
    unset term_kill_needed
    trap 'handle_term' TERM INT
}

handle_term()
{
    if [ "${term_child_pid}" ]; then
        kill -TERM "${term_child_pid}" 2>/dev/null
    else
        term_kill_needed="yes"
    fi
}

wait_term()
{
    term_child_pid=$!
    if [ "${term_kill_needed}" ]; then
        kill -TERM "${term_child_pid}" 2>/dev/null
    fi
    wait ${term_child_pid} 2>/dev/null
    trap - TERM INT
    wait ${term_child_pid} 2>/dev/null
}

# Disable forking, else the container won't shutdown gracefully
prep_term
java -Xmx1024m -Djava.net.useSystemProxies=true -Dhttp.nonProxyHosts="172.28.0.*" -jar cq-quickstart.jar -nofork -nointeractive -r dynamicmedia -r publish -port 4503 &
wait_term