FROM debian:12-slim AS builder

WORKDIR /src

# Latest CMake
RUN apt update && apt install -y \
    wget \
    tar \
    && rm -rf /var/lib/apt/lists/*
RUN LATEST_VERSION=$(wget -qO- https://api.github.com/repos/Kitware/CMake/releases/latest | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/') && \
    wget https://github.com/Kitware/CMake/releases/download/v${LATEST_VERSION}/cmake-${LATEST_VERSION}-linux-x86_64.sh -O cmake-install.sh && \
    chmod +x cmake-install.sh && \
    ./cmake-install.sh --skip-license --prefix=/usr/local
RUN rm -f cmake-install.sh

COPY scripts /scripts
RUN bash /scripts/debian-12/1-install-deps.sh

COPY . .

RUN bash ./scripts/debian-12/1.5-git-safe.sh
RUN bash ./scripts/debian-12/2-configure.sh
RUN bash ./scripts/debian-12/3-build.sh


FROM debian:12-slim

COPY scripts /scripts
RUN bash /scripts/debian-12/4-install-runtime-deps.sh

WORKDIR /app

COPY --from=builder /src/bin/BeamMP-Server /app/BeamMP-Server

EXPOSE 30814

CMD ["./BeamMP-Server"]
