FROM clux/muslrust:1.64.0 as backend
WORKDIR /src
COPY ./Multidirection-backend/Cargo.toml ./Multidirection-backend/Cargo.lock ./
RUN cargo vendor
COPY ./Multidirection-backend/ ./
RUN cargo build -r

FROM node:16.18-alpine as frontend
WORKDIR /src
COPY ./Multidirection-frontend/package.json ./
RUN npm i
COPY ./Multidirection-frontend/ ./
RUN npm run build

FROM alpine
WORKDIR /app
COPY --from=frontend /src/dist/ ./static/
COPY --from=backend /src/target/x86_64-unknown-linux-musl/release/multidirection-backend ./
ENTRYPOINT [ "./multidirection-backend" ]
EXPOSE 8080
