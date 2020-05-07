FROM python:3.7.4

RUN apt-get update && apt-get install -y build-essential
RUN mkdir /backend/
WORKDIR /backend/

ADD requirements.txt requirements.txt

RUN python -m venv /venv \
    && /venv/bin/pip install -U pip \
    && LIBRARY_PATH=/lib:/usr/lib /bin/sh -c "/venv/bin/pip install --no-cache-dir -r requirements.txt"

RUN touch /venv/bin/activate

ARG version
ARG prod
ARG githubtoken

COPY ./ ./

RUN if [ "$prod" = "true" ]; then make release v=$version githubtoken=$githubtoken; else if [ "$version" != "" ]; then make build-release v=$version; fi ; fi
RUN ls -la /backend/
RUN rm -rf /backend/.git/
RUN ls -la /backend/