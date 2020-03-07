FROM node:slim as builder
WORKDIR /app
ADD package*.json ./
RUN npm install
ADD . /app
RUN npm run build

FROM nginx:alpine
ADD nginx.conf /etc/nginx/nginx.conf
COPY --from=builder /app/dist /app


