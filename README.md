# Optimized Docker Image with Poetry

This project demonstrates an optimized approach to building Docker images for Python applications using Poetry. The goal is to reduce build times and image size while maintaining reproducibility and efficiency.

## Optimization Techniques Used

### 1. **Pinned Poetry Version**
- Ensures deterministic builds by avoiding unexpected changes due to Poetry updates.
- Installed Poetry with a fixed version using:
  ```dockerfile
  RUN pip install poetry==<version>
  ```

### 2. **Minimal File Copying**
- Avoids copying unnecessary files like `.venv`, ensuring efficient layer caching.
- Only essential files (`pyproject.toml`, `poetry.lock`, and application source) are copied:
  ```dockerfile
  COPY pyproject.toml poetry.lock ./
  COPY <important parts of application>
  ```

### 3. **Excluding Development Dependencies**
- Reduces image size by installing only production dependencies with:
  ```dockerfile
  RUN poetry install --without dev
  ```

### 4. **Cleaning Poetry Cache**
- Prevents cache bloat by removing Poetry's cache after dependency installation:
  ```dockerfile
  RUN poetry install --without dev && rm -rf $POETRY_CACHE_DIR
  ```

### 5. **Layer Caching Optimization**
- Installs dependencies before copying the application code to avoid reinstalling dependencies on code changes:
  ```dockerfile
  RUN poetry install --without dev --no-root
  COPY <application>
  RUN poetry install --without dev
  ```

### 6. **Multi-Stage Build for Slimmer Image**
- Uses a `builder` stage for installation and a `runtime` stage to keep the final image minimal:
  ```dockerfile
  FROM python:3.11-buster as builder
  ...
  FROM python:3.11-slim-buster as runtime
  COPY --from=builder ${VIRTUAL_ENV} ${VIRTUAL_ENV}
  ```
- Results in a much smaller final image (~170MB vs. >1GB).

### 7. **Buildkit Cache Mounts for Faster Builds**
- Enables caching for dependency installations, speeding up repeated builds:
  ```dockerfile
  RUN --mount=type=cache,target=$POETRY_CACHE_DIR poetry install --without dev --no-root
  ```

## Benefits
- 🚀 **Faster builds**: Avoids redundant installations by leveraging Docker layer caching.
- 📉 **Smaller image size**: Reduces unnecessary files and dependencies.
- 🔄 **Reproducibility**: Ensures consistency by pinning Poetry versions and dependencies.

## Usage
To build and run the Docker container:
```sh
DOCKER_BUILDKIT=1 docker build -t optimized-python-app .
docker run --rm optimized-python-app
```

## Conclusion
By implementing these optimizations, the project achieves efficient, fast, and lightweight Docker builds while maintaining flexibility and ease of development.

