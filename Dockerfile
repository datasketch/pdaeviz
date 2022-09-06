FROM --platform=linux/amd64 rocker/r-ver:4.2.1

RUN apt-get update && apt-get install -y \
  ca-certificates \
  lsb-release \
  libcurl4-openssl-dev \
  libv8-dev \
  libxml2-dev \
  zlib1g-dev \
  imagemagick \
  libmagick++-dev \
  libudunits2-dev \
  gdal-bin \
  libproj-dev \
  libgdal-dev \
  libgeos-dev \
  libgeos++-dev \
  protobuf-compiler \
  libprotobuf-dev \
  libjq-dev \
  libharfbuzz-dev \
  libfribidi-dev \
  && rm -rf /var/lib/apt/lists/*

ARG GITHUB_PAT

RUN echo "options(repos = c(CRAN = 'https://cran.rstudio.com/'), download.file.method = 'libcurl', Ncpus = 4)" >> /usr/local/lib/R/etc/Rprofile.site

RUN R -e 'install.packages("remotes")'

RUN Rscript -e 'remotes::install_version("dotenv", upgrade="never", version = "1.0.3")'

RUN Rscript -e 'remotes::install_version("jsonlite", upgrade="never", version = "1.8.0")'

RUN Rscript -e 'remotes::install_version("tidyverse", upgrade="never", version = "1.3.2")'

RUN Rscript -e 'remotes::install_version("shiny", upgrade="never", version = "1.7.2")'

RUN Rscript -e 'remotes::install_version("ckanr", upgrade="never", version = "0.6.0")'

RUN Rscript -e 'remotes::install_version("DT", upgrade="never", version = "0.23")'

RUN Rscript -e 'remotes::install_version("devtools", upgrade="never", version = "2.4.4")'

RUN Rscript -e 'remotes::install_github("datasketch/shinypanels@8be05c0ff074000f82f5903d597ce9e0eb0fc6b2")'

RUN Rscript -e 'remotes::install_github("datasketch/shinyinvoer@dd8178db99cac78f0abbd236e83e07bf1f22ba18")'

RUN Rscript -e 'remotes::install_github("datasketch/homodatum@55adc0cd255e02980dddf0873050c59cf0fd9df4")'

RUN Rscript -e 'remotes::install_github("datasketch/pseudoviz@e1372fa089d9963fef1fc4e2a7caa0939cf40fb2")'

RUN Rscript -e 'remotes::install_github("datasketch/hgchmagic@1c2126cb2722071855fa7133bffcd32a805399e1")'

RUN Rscript -e 'remotes::install_version("readODS", upgrade="never", version = "1.7.0")'

RUN mkdir /build_zone

ADD . /build_zone

WORKDIR /build_zone

ARG API_TOKEN

ENV CKAN_API_TOKEN=${api_token}

RUN touch .Renviron

RUN echo "CKAN_API_TOKEN=${CKAN_API_TOKEN}" >> .Renviron

RUN R -e 'remotes::install_local(upgrade="never")'

RUN rm -rf /build_zone

EXPOSE 3838

CMD R -e "options('shiny.port'=3838,shiny.host='0.0.0.0');pdaeviz::run_app()"
