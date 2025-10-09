.PHONY: help build build-local run stop restart clean clean-all logs logs-db shell shell-db push deploy build-lpk install-lpk uninstall-lpk deploy-fast all

# LPK configuration
LAZYCAT_BOX_NAME ?= $(lzc-cli box default)

# Default configuration
DOCKER_REGISTRY ?= docker-registry-ui.${LAZYCAT_BOX_NAME}.heiyu.space
IMAGE_NAME ?= strapi
IMAGE_TAG ?= latest
FULL_IMAGE ?= $(DOCKER_REGISTRY)/$(IMAGE_NAME):$(IMAGE_TAG)
PLATFORM ?= linux/amd64
CONTAINER_NAME ?= strapi-app

# Port configuration
STRAPI_PORT ?= 1339

# Volume configuration
DATA_DIR ?= $(PWD)/data

# LPK configuration
PACKAGE_NAME ?= cloud.lazycat.app.liu.strapi

HELP_FUN = \
	%help; while(<>){push@{$$help{$$2//'options'}},[$$1,$$3] \
	if/^([\w-_]+)\s*:.*\#\#(?:@(\w+))?\s(.*)$$/}; \
	print"\033[1m$$_:\033[0m\n", map"  \033[36m$$_->[0]\033[0m".(" "x(20-length($$_->[0])))."$$_->[1]\n",\
	@{$$help{$$_}},"\n" for keys %help; \

help: ##@General Show this help
	@echo -e "Usage: make \033[36m<target>\033[0m\n"
	@perl -e '$(HELP_FUN)' $(MAKEFILE_LIST)

build: ##@Build Build Docker image for platform $(PLATFORM)
	@echo "Building image: $(FULL_IMAGE) for platform $(PLATFORM)"
	docker build --platform $(PLATFORM) \
		-t $(FULL_IMAGE) .
	@echo "Image built successfully!"

build-local: ##@Build Build Docker image for local platform
	@echo "Building image for local platform: $(FULL_IMAGE)"
	docker build -t $(FULL_IMAGE) .
	@echo "Image built successfully!"

run: ##@Run Run container locally with Docker Compose
	@echo "Starting Strapi with Docker Compose..."
	docker compose up -d
	@echo "Container started successfully!"
	@echo "Strapi Admin: http://localhost:$(STRAPI_PORT)/admin"
	@echo "Strapi API: http://localhost:$(STRAPI_PORT)/api"

stop: ##@Run Stop and remove containers
	@echo "Stopping containers..."
	docker compose down
	@echo "Containers stopped and removed!"

restart: stop run ##@Run Restart containers

logs: ##@Run Show Strapi container logs
	docker compose logs -f strapi

logs-db: ##@Run Show PostgreSQL container logs
	docker compose logs -f postgres

shell: ##@Run Open shell in Strapi container
	docker compose exec strapi sh

shell-db: ##@Run Open shell in PostgreSQL container
	docker compose exec postgres psql -U strapi -d strapi

clean: stop ##@Maintenance Stop containers (preserve volumes)
	@echo "Containers stopped and removed"
	@echo "Note: Docker volumes are preserved"
	@echo "To clean volumes, run: make clean-all"

clean-all: ##@Maintenance Stop containers and remove volumes
	@echo "Stopping containers and removing volumes..."
	docker compose down -v
	@echo "All cleaned!"

push: ##@Deploy Push image to registry
	@echo "Pushing image: $(FULL_IMAGE)"
	docker push $(FULL_IMAGE)
	@echo "Image pushed successfully!"

build-lpk: ##@Deploy Build LPK package (requires lzc-cli)
	@echo "Building LPK package..."
	lzc-cli project build
	@echo "LPK package built successfully!"

install-lpk: ##@Deploy Install LPK package locally
	@echo "Installing LPK package..."
	@LPK_FILE=$$(ls -t *.lpk 2>/dev/null | head -n 1); \
	if [ -z "$$LPK_FILE" ]; then \
		echo "Error: No LPK file found. Run 'make build-lpk' first"; \
		exit 1; \
	fi; \
	echo "Installing $$LPK_FILE..."; \
	lzc-cli app install "$$LPK_FILE"
	@echo "Installation completed!"

uninstall: ##@Deploy Uninstall LPK package
	@echo "Uninstalling package: $(PACKAGE_NAME)"
	lzc-cli app uninstall $(PACKAGE_NAME)
	@echo "Uninstall completed!"

deploy: build push build-lpk install-lpk ##@Deploy Full deployment (build + push + package + install)

deploy-fast: build-lpk install-lpk ##@Deploy Quick deployment (package + install, skip image build)

all: deploy ##@Aliases Alias for deploy (default target)
