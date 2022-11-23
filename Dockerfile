FROM python:3.10-slim-bullseye

RUN apt-get -y update && \
   apt-get install -y --no-install-recommends build-essential  \
   curl wget nginx ca-certificates npm \
   && npm install pm2 -g \
   && pip install --upgrade pip setuptools pipenv \
   && rm -rf /var/lib/apt/lists/*

# Install python dependencies in /.venv
COPY Pipfile .
COPY Pipfile.lock .
RUN PIPENV_VENV_IN_PROJECT=1 pipenv install --deploy
ENV PATH="/.venv/bin:$PATH"


# add non-root user
RUN groupadd -r user && useradd -r -g user user

# Download the model while building the image - so when the container instance is created the model is right there.
# download the model into user home directory and change to root user for other steps
WORKDIR /home/user
RUN chown -R user /home/user
USER user
RUN python3 -c "from transformers import pipeline; classifier = pipeline('zero-shot-classification', model='facebook/bart-large-mnli')"
USER root

# set up the program iin image
COPY app /home/user/app
WORKDIR /home/user/app

# change ownership of app folder
RUN chown -R user /home/user/app

# expose port
EXPOSE 8080

CMD ["uvicorn", "--host=0.0.0.0", "--port=8080", "app:app"]
