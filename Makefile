
.PHONY: validate lint security test dev-up dev-down

validate: lint security
	@echo "Validation completed"

lint:
	yamllint automation infrastructure monitoring network environments
	shellcheck scripts/*.sh

security:
	gitleaks dir .

test:
	pytest -v tests/

dev-up:
	docker compose \
		-f automation/compose.yaml \
		-f automation/compose.dev.yaml \
		up -d

dev-down:
	docker compose \
		-f automation/compose.yaml \
		-f automation/compose.dev.yaml \
		down


