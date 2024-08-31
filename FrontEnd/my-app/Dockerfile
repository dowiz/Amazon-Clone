FROM node:latest
WORKDIR /app
COPY . /app
RUN npm install && npm run build && npm install -g serve
ENTRYPOINT ["serve", "-s", "build", "-l", "3000"]
