#!/bin/bash

function install_phantomjs() {
    echo '>>> Installing PhantomJS'

    curl --output /usr/local/bin/phantomjs https://s3.amazonaws.com/circle-downloads/phantomjs-2.1.1
}
