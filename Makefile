.PHONY: help clean build publish install install-dev test test-all lint format

help:
	@echo "PyDevMate - Available commands:"
	@echo "  make clean        - Remove build artifacts and cache files"
	@echo "  make build        - Build distribution packages"
	@echo "  make publish      - Clean, build, and upload to PyPI"
	@echo "  make test-publish - Publish to TestPyPI (for testing)"
	@echo "  make install      - Install package in current environment"
	@echo "  make install-dev  - Install package in development mode"
	@echo "  make test         - Run all tests using main.py"
	@echo "  make test-all     - Run tests for all utilities"

clean:
	@echo "Cleaning build artifacts..."
	rm -rf dist/
	rm -rf build/
	rm -rf *.egg-info
	rm -rf PyDevMate.egg-info
	find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true
	find . -type f -name "*.pyc" -delete
	find . -type d -name "__cacheit__" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name "__saveit__" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name "__logit__" -exec rm -rf {} + 2>/dev/null || true
	@echo "Clean complete!"

build: clean
	@echo "Building distribution packages..."
	python -m build
	@echo "Build complete! Files in dist/:"
	@ls -lh dist/

publish: build
	@echo "Publishing to PyPI..."
	python -m twine upload dist/*
	@echo "Package published successfully!"

test-publish: build
	@echo "Publishing to TestPyPI..."
	python -m twine upload --repository testpypi dist/*
	@echo "Package published to TestPyPI!"
	@echo "Install with: pip install --index-url https://test.pypi.org/simple/ PyDevMate"

install:
	@echo "Installing PyDevMate..."
	pip install .

install-dev:
	@echo "Installing PyDevMate in development mode..."
	pip install -e .

test:
	@echo "Running tests..."
	python main.py

test-all:
	@echo "Running all utility tests..."
	python main.py

# Install build tools if needed
install-tools:
	@echo "Installing build tools..."
	pip install --upgrade build twine wheel setuptools

# Check package before publishing
check:
	@echo "Checking distribution packages..."
	python -m twine check dist/*

# Show current version
version:
	@echo "Current version:"
	@grep "version = " pyproject.toml | head -1
	@grep "version=" setup.py | head -1
