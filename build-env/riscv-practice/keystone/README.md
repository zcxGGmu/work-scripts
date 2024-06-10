# Testing Keystone with Qemu

## Start with Docker

    docker pull keystoneenclaveorg/keystone:master
    docker run keystoneenclaveorg/keystone:master

    docker run -it --entrypoint /bin/bash keystoneenclaveorg/keystone:master

    # in container
    cd /keystone
    source source.sh
    cd build
    make run-tests
    ./scripts/run-qemu.sh
Login as root with the password sifive

     #In qemu
     insmod keystone-driver.ko
     ./attestor.ke

## Start without Docker

    bash -x prepare.sh
    cmake_build.sh
    ./scripts/run-qemu.sh