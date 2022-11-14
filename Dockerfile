# gandalfmagic/kustomize:4.5.7-2
FROM alpine:3.16.2 as build

RUN apk --no-cache add wget && mkdir /downloads

RUN wget https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv4.5.7/kustomize_v4.5.7_linux_amd64.tar.gz 2>/dev/null && \
    tar xzf kustomize_v4.5.7_linux_amd64.tar.gz && rm *.tar.gz && \
    mv kustomize /downloads/

RUN wget https://get.helm.sh/helm-v3.10.1-linux-amd64.tar.gz 2>/dev/null && \
    tar xzf helm-v3.10.1-linux-amd64.tar.gz && rm *.tar.gz && \
    mv linux-amd64/helm /downloads/

RUN wget https://github.com/yannh/kubeconform/releases/download/v0.5.0/kubeconform-linux-amd64.tar.gz 2>/dev/null && \
    tar xzf kubeconform-linux-amd64.tar.gz && rm *.tar.gz && \
    mv kubeconform /downloads/

RUN wget https://releases.hashicorp.com/vault/1.12.1/vault_1.12.1_linux_amd64.zip 2>/dev/null && \
    unzip vault_1.12.1_linux_amd64.zip && rm vault_*_linux_amd64.zip && \
    mv vault /downloads/

# IMPORTANT: the version of kubectl must be maintained to be aligned with the server in use
ADD https://storage.googleapis.com/kubernetes-release/release/v1.23.11/bin/linux/amd64/kubectl /downloads/kubectl

ADD https://github.com/zegl/kube-score/releases/download/v1.14.0/kube-score_1.14.0_linux_amd64 /downloads/kube-score

ADD https://github.com/mikefarah/yq/releases/download/v4.30.2/yq_linux_amd64 /downloads/yq

RUN chmod 755 /downloads/*

FROM alpine:3.16.2

ENV KUBECONFIG=/ect/kube/config

RUN apk --no-cache add bash coreutils curl jq

COPY --from=build /downloads/* /usr/local/bin/

ENTRYPOINT [ "/usr/local/bin/kustomize" ]
