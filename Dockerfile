FROM node:16-alpine AS build

WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install
COPY . .
RUN npm run build

FROM node:16-alpine

WORKDIR /app
COPY --from=build /app/build ./build
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/package*.json ./
ENV NODE_ENV=production
EXPOSE 3000
RUN npm install -g serve
CMD ["serve", "-s", "build", "-l", "3000"]