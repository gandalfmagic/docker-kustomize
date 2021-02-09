# gandalfmagic/kustomize:3.8.6-1
FROM alpine:3.12.0 as build

RUN apk --no-cache add wget && mkdir /downloads

RUN wget https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv3.8.6/kustomize_v3.8.6_linux_amd64.tar.gz 2>/dev/null && \
    tar xzvf kustomize_v3.8.6_linux_amd64.tar.gz && rm *.tar.gz && \
    mv kustomize /downloads/

RUN wget https://github.com/instrumenta/kubeval/releases/download/0.15.0/kubeval-linux-amd64.tar.gz 2>/dev/null && \
    tar xzvf kubeval-linux-amd64.tar.gz && rm *.tar.gz && \
    mv kubeval /downloads/

ADD https://storage.googleapis.com/kubernetes-release/release/v1.19.4/bin/linux/amd64/kubectl /downloads/kubectl
ADD https://github.com/zegl/kube-score/releases/download/v1.10.1/kube-score_1.10.1_linux_amd64 /downloads/kube-score

RUN chmod 755 /downloads/*

FROM alpine:3.12.0

ENV KUBECONFIG=/ect/kube/config

RUN apk --no-cache add bash coreutils curl jq

COPY --from=build /downloads/* /usr/local/bin/

ENTRYPOINT [ "/usr/local/bin/kustomize" ]
