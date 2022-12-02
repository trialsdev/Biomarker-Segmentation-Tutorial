FROM python:3.6

# Allow statements and log messages to immediately appear in the Cloud Run logs
ENV PYTHONUNBUFFERED True

ENV APP_HOME /dummy_app
WORKDIR $APP_HOME

COPY . ./

# Install prerequisites
RUN pip install -r requirements.txt

CMD exec gunicorn --bind :$PORT --workers 1 --threads 8 --timeout 0 app:app
