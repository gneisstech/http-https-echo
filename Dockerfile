# ---- Base Node ----
FROM alpine:3 AS base
# install node
RUN apk add --no-cache nodejs-current npm tini
# set working directory
WORKDIR /app
# Set tini as entrypoint
ENTRYPOINT ["/sbin/tini", "--"]
# copy project file
COPY package.json .

#
# ---- Dependencies ----
FROM base AS dependencies
# install node packages
RUN npm set progress=false && npm config set depth 0
RUN npm install --only=production

#
# ---- Release ----
FROM base AS release
# copy production node_modules
COPY --from=dependencies /app/node_modules ./node_modules
# copy app sources
COPY . .
RUN apk --no-cache add openssl && sh generate-cert.sh && rm -rf /var/cache/apk/*
CMD npm run start -- --max-http-header-size=32768
