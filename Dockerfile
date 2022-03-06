FROM beauraines/r-container as base

FROM base as dashboard
COPY processDashboard.sh .
COPY upload.R .

FROM dashboard

ARG AWS_KEY
ARG AWS_SECRET
ARG AWS_REGION
ARG AWS_BUCKET

ENV AWS_KEY=${AWS_KEY}
ENV AWS_SECRET=${AWS_SECRET}
ENV AWS_REGION=${AWS_REGION}
ENV AWS_BUCKET=${AWS_BUCKET}

CMD /bin/bash processDashboard.sh


