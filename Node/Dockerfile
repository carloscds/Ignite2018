FROM node:carbon

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install

# Bundle app source
COPY . .

EXPOSE 80
EXPOSE 443
CMD [ "npm", "start" ]
