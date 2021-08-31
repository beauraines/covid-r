FROM beauraines/r-container as base

FROM base as dashboard
COPY processDashboard.sh .
COPY upload.R .

FROM dashboard
ARG AZURE_STORAGE_ACCOUNT
ARG AZURE_STORAGE_KEY
ENV AZURE_STORAGE_ACCOUNT=${AZURE_STORAGE_ACCOUNT}
ENV AZURE_STORAGE_KEY=${AZURE_STORAGE_KEY}
CMD /bin/bash processDashboard.sh


