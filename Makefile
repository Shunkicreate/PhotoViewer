# Makefile

ifndef ENV_FILE
    ENV_FILE = k8s/.env
endif

export $(shell sed -E 's/^([^#]*)=(.*)$/export \1="\2"/g' $(ENV_FILE))

K8S_DIR = k8s

.PHONY: all deploy apply clean

all: deploy

deploy: apply

# 1) 生成された YAML を kubectl apply
apply:
	@echo "=== kubectl apply ==="
	kubectl apply -f $(K8S_DIR) --request-timeout=5m

clean:
	@rm -rf $(K8S_DIR)
