#!/usr/bin/env python3
"""
FastAPI Clean Architecture Project Scaffolder
Usage: python init_project.py <project_name>
"""

import argparse
import shutil
from pathlib import Path


TEMPLATES = {
    "app/__init__.py": "",
    "app/main.py": "main.py",
    "app/core/__init__.py": "",
    "app/core/config.py": "config.py",
    "app/core/dependencies.py": "dependencies.py",
    "app/routers/__init__.py": "routers_init.py",
    "app/routers/health.py": "router_health.py",
    "app/services/__init__.py": "",
    "app/services/health_service.py": "service_health.py",
    "app/schemas/__init__.py": "",
    "app/schemas/health.py": "schemas_health.py",
    "tests/__init__.py": "",
    "tests/conftest.py": "conftest.py",
}

ROOT_FILES = {
    "Dockerfile": "Dockerfile",
    "docker-compose.yml": "docker-compose.yml",
    "docker-compose.override.yml": "docker-compose.override.yml",
    "docker-compose.prod.yml": "docker-compose.prod.yml",
    "requirements.txt": "requirements.txt",
    "pyproject.toml": "pyproject.toml",
}


def create_project(project_name: str, output_dir: Path):
    assets_dir = Path(__file__).parent
    project_dir = output_dir / project_name

    if project_dir.exists():
        print(f"Error: Directory '{project_dir}' already exists")
        return 1

    project_dir.mkdir(parents=True)

    for target_path, source_file in TEMPLATES.items():
        target = project_dir / target_path
        target.parent.mkdir(parents=True, exist_ok=True)

        if source_file:
            source = assets_dir / source_file
            if source.exists():
                shutil.copy(source, target)
            else:
                target.touch()
        else:
            target.touch()

    for target_file, source_file in ROOT_FILES.items():
        target = project_dir / target_file
        source = assets_dir / source_file
        if source.exists():
            shutil.copy(source, target)

    env_example = project_dir / ".env.example"
    env_example.write_text("PROJECT_NAME=fastapi-app\nVERSION=0.1.0\nDEBUG=false\n")

    readme = project_dir / "README.md"
    readme.write_text(f"# {project_name}\n\nFastAPI Clean Architecture Application\n")

    print(f"Project '{project_name}' created at {project_dir}")
    print("\nNext steps:")
    print(f"  cd {project_name}")
    print("  cp .env.example .env")
    print("  docker compose up -d")
    return 0


def main():
    parser = argparse.ArgumentParser(description="Scaffold FastAPI Clean Architecture project")
    parser.add_argument("project_name", help="Name of the project")
    parser.add_argument("-o", "--output", default=".", help="Output directory")

    args = parser.parse_args()
    return create_project(args.project_name, Path(args.output))


if __name__ == "__main__":
    exit(main())
