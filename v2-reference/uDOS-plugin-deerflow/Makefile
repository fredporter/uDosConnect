.PHONY: bootstrap validate run-example test

bootstrap:
	bash scripts/bootstrap.sh

validate:
	python3 src/python/udos_plugin_deerflow/adapter.py --validate examples/workflows/sample.workflow.json

run-example:
	python3 src/python/udos_plugin_deerflow/adapter.py --workflow examples/workflows/sample.workflow.json --dry-run

test:
	python3 -m unittest discover -s tests -p "test_*.py"
