FROM danidemi/docker-reveal.js:latest
ARG presentation

EXPOSE 8000
COPY ./${presentation} /slides/index.html
RUN rm index.html \
    && ln -s /reveal.js /reveal.js/reveal.js
