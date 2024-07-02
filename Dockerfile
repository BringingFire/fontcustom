FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update

RUN apt-get install -y build-essential git curl ruby ruby-dev zlib1g-dev fontforge

RUN curl -sL https://deb.nodesource.com/setup_20.x | bash
RUN apt-get install -y nodejs

ADD . /fontcustom-src
RUN <<EOF
cd /fontcustom-src
gem build fontcustom.gemspec
gem install fontcustom-2.0.0.gem
cd /
rm -rf /fontcustom-src
EOF

RUN git clone --recursive https://github.com/google/woff2.git
RUN cd woff2 && make clean all && mv woff2_compress /usr/local/bin/ && mv woff2_decompress /usr/local/bin/

RUN git clone https://github.com/bramstein/sfnt2woff-zopfli.git sfnt2woff-zopfli
RUN cd sfnt2woff-zopfli && make && mv sfnt2woff-zopfli /usr/local/bin/sfnt2woff
