# ARMv7 python docker builder
Build Python 3.7.x for ARMv7 from source. Can be used for Xiaomi Vacuum cleaner. 

1) define ARGs in DockerFile:<br>
ARG PYTHON_VERSION=**3.7.5**<br>
ARG OPENSSL_VERSION=**1.1.1b**<br>
ARG OPENSSL_PATH=**/usr/local/openssl**<br>

2) build image:<br>
``docker build -t py37-builder .``<br>
**OR** use docker build command with args(can be used without redefining args in Dockerfile):<br>
``docker build --build-arg PYTHON_VERSION=3.7.5 --build-arg OPENSSL_VERSION=1.1.1b --build-arg OPENSSL_PATH=/usr/local/openssl -t py37-builder .``
3) run docker image: <br>
``docker run -v ${{path to your host src folder}}/src:/src -v ${{path to your host target folder}}/target:/target py37-builder``
<p>
  
  
After executing, you will get your compiled python in the target folder<br>

Important! In case of Xiaomi vacuum cleaner when pip install is not working (error like `Can't connect to HTTPS URL because the SSL module is not available.`) You must put the following files `lybcrypto.so.*`, `libssl.so.*` from `target` dir to the OPENSSL_PATH(that we used at compiling OpenSSL) directory on Xiaomi Vacuum cleaner.
