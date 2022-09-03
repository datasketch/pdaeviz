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
  && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /usr/local/lib/R/etc/ /usr/lib/R/etc/
RUN echo "options(renv.config.pak.enabled = TRUE, repos = c(CRAN = 'https://cran.rstudio.com/'), download.file.method = 'libcurl', Ncpus = 4)" | tee /usr/local/lib/R/etc/Rprofile.site | tee /usr/lib/R/etc/Rprofile.site
RUN R -e 'install.packages(c("renv","remotes"))'
ARG GITHUB_PAT
COPY renv.lock renv.lock
RUN R -e 'renv::restore()'
RUN mkdir /build_zone
ADD . /build_zone
WORKDIR /build_zone
RUN R -e 'renv::install("remotes");remotes::install_local(upgrade="never")'
RUN rm -rf /build_zone
EXPOSE 3838
CMD R -e "options('shiny.port'=3838,shiny.host='0.0.0.0');pdaeviz::run_app()"