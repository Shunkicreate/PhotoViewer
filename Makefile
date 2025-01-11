# Makefile (プロジェクトルートに置く)

ifndef ENV_FILE
    ENV_FILE = k8s/.env
endif

export $(shell sed -E 's/^([^#]*)=(.*)$/export \1="\2"/g' $(ENV_FILE))

# テンプレート & 出力先
K8S_TEMPLATES_DIR = k8s
K8S_OUTPUT_DIR = k8s/generated

FRONTEND_DEPLOYMENT_TEMPLATE = $(K8S_TEMPLATES_DIR)/frontend-deployment.yaml.template
FRONTEND_SERVICE_TEMPLATE = $(K8S_TEMPLATES_DIR)/frontend-service.yaml.template
FRONTEND_HPA_TEMPLATE = $(K8S_TEMPLATES_DIR)/frontend-hpa.yaml.template

BACKEND_DEPLOYMENT_TEMPLATE = $(K8S_TEMPLATES_DIR)/backend-deployment.yaml.template
BACKEND_SERVICE_TEMPLATE = $(K8S_TEMPLATES_DIR)/backend-service.yaml.template
BACKEND_HPA_TEMPLATE = $(K8S_TEMPLATES_DIR)/backend-hpa.yaml.template

FRONTEND_DEPLOYMENT_FILE = $(K8S_OUTPUT_DIR)/frontend-deployment.yaml
FRONTEND_SERVICE_FILE = $(K8S_OUTPUT_DIR)/frontend-service.yaml
FRONTEND_HPA_FILE = $(K8S_OUTPUT_DIR)/frontend-hpa.yaml

BACKEND_DEPLOYMENT_FILE = $(K8S_OUTPUT_DIR)/backend-deployment.yaml
BACKEND_SERVICE_FILE = $(K8S_OUTPUT_DIR)/backend-service.yaml
BACKEND_HPA_FILE = $(K8S_OUTPUT_DIR)/backend-hpa.yaml

.PHONY: all deploy generate-yaml apply clean

all: deploy

deploy: prepare-dir generate-yaml apply

prepare-dir:
	@mkdir -p $(K8S_OUTPUT_DIR)

# 1) テンプレートを envsubst で置換し、本番用 YAML を生成
generate-yaml:
	@echo "=== Generating YAML with envsubst ==="
	envsubst < $(FRONTEND_DEPLOYMENT_TEMPLATE) > $(FRONTEND_DEPLOYMENT_FILE)
	envsubst < $(FRONTEND_SERVICE_TEMPLATE)    > $(FRONTEND_SERVICE_FILE)
	envsubst < $(FRONTEND_HPA_TEMPLATE)        > $(FRONTEND_HPA_FILE)

	envsubst < $(BACKEND_DEPLOYMENT_TEMPLATE)  > $(BACKEND_DEPLOYMENT_FILE)
	envsubst < $(BACKEND_SERVICE_TEMPLATE)     > $(BACKEND_SERVICE_FILE)
	envsubst < $(BACKEND_HPA_TEMPLATE)         > $(BACKEND_HPA_FILE)

# 2) 生成された YAML を kubectl apply
apply:
	@echo "=== kubectl apply ==="
	kubectl apply -f $(K8S_OUTPUT_DIR)

clean:
	@rm -rf $(K8S_OUTPUT_DIR)
