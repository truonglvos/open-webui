FROM --platform=$BUILDPLATFORM node:18-alpine AS build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm install

COPY . .
ENV NODE_OPTIONS="--max-old-space-size=8192"
RUN npm run build

FROM nginx:alpine AS production

COPY --from=build /app/build /usr/share/nginx/html

COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]