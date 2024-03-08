# Base node image
FROM node:18-alpine AS node

COPY . /app
WORKDIR /app

# Add the `wait-for-it.sh` script to the image and make it executable
# Can be used later in docker-compose to make it wait for other services
COPY ./wait-for-it.sh /wait-for-it.sh
RUN chmod +x /wait-for-it.sh

# Allow mounting of these files, which have no default
# values.
RUN touch .env
RUN npm config set fetch-retry-maxtimeout 300000
RUN apk add --no-cache g++ make python3 py3-pip
RUN npm install -g node-gyp
RUN apk --no-cache add curl && \
    npm install

# React client build
ENV NODE_OPTIONS="--max-old-space-size=2048"
RUN npm run frontend

# Node API setup
EXPOSE 3080
ENV HOST=0.0.0.0
CMD ["npm", "run", "backend"]

# Optional: for client with nginx routing
FROM nginx:stable-alpine AS nginx-client
WORKDIR /usr/share/nginx/html
COPY --from=node /app/client/dist /usr/share/nginx/html
COPY client/nginx.conf /etc/nginx/conf.d/default.conf
ENTRYPOINT ["nginx", "-g", "daemon off;"]
