#!/usr/bin/env python3
"""Register a project-scoped Lean 4 Jupyter kernel."""

from __future__ import annotations

import argparse
import json
import os
import platform
import stat
from pathlib import Path
from typing import Any


def default_kernels_dir() -> Path:
    """Return the user-level Jupyter kernelspec directory for this platform."""
    home = Path.home()
    if platform.system() == "Darwin":
        return home / "Library" / "Jupyter" / "kernels"
    if platform.system() == "Windows":
        appdata = os.environ.get("APPDATA")
        if appdata:
            return Path(appdata) / "jupyter" / "kernels"
    return home / ".local" / "share" / "jupyter" / "kernels"


def resolve_existing_dir(path: str, label: str) -> Path:
    """Resolve a path and fail clearly if it is not an existing directory."""
    resolved = Path(path).expanduser().resolve()
    if not resolved.is_dir():
        raise SystemExit(f"{label} does not exist or is not a directory: {resolved}")
    return resolved


def resolve_python(venv_dir: Path, python_path: str | None) -> Path:
    """Resolve the Python executable used to launch lean4_jupyter."""
    if python_path:
        python = Path(python_path).expanduser().resolve()
    else:
        python = venv_dir / ("Scripts/python.exe" if platform.system() == "Windows" else "bin/python")
    if not python.exists():
        raise SystemExit(f"Python executable does not exist: {python}")
    return python


def launcher_text(project_root: Path, python: Path, extra_path_entries: list[Path]) -> str:
    """Build the POSIX launcher script for a project-scoped Lean kernel."""
    path_entries = ":".join(str(path) for path in extra_path_entries)
    return f"""#!/usr/bin/env bash
set -euo pipefail

cd {json.dumps(str(project_root))}
export PATH={json.dumps(path_entries + ":$PATH")}
exec {json.dumps(str(python))} -m lean4_jupyter "$@"
"""


def write_launcher(path: Path, text: str, dry_run: bool) -> None:
    """Write an executable launcher script."""
    if dry_run:
        return
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text, encoding="utf-8")
    current_mode = path.stat().st_mode
    path.chmod(current_mode | stat.S_IXUSR | stat.S_IXGRP | stat.S_IXOTH)


def write_kernel_json(path: Path, data: dict[str, Any], dry_run: bool) -> None:
    """Write kernel.json."""
    if dry_run:
        return
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(data, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")


def build_parser() -> argparse.ArgumentParser:
    """Create the command-line parser."""
    parser = argparse.ArgumentParser(
        description="Register a project-scoped Lean 4 Jupyter kernel."
    )
    parser.add_argument(
        "--project-root",
        default=".",
        help="Lake project root used as the kernel working directory.",
    )
    parser.add_argument(
        "--venv",
        default=".venv",
        help="Virtualenv directory relative to project root or absolute path.",
    )
    parser.add_argument(
        "--kernel-name",
        required=True,
        help="Jupyter kernelspec directory name, e.g. qnf-lean4.",
    )
    parser.add_argument(
        "--display-name",
        required=True,
        help="Human-facing kernel name shown in VS Code and Jupyter.",
    )
    parser.add_argument(
        "--python",
        help="Python executable to run `-m lean4_jupyter`; defaults to <venv>/bin/python.",
    )
    parser.add_argument(
        "--launcher-name",
        help="Launcher filename under <venv>/bin; defaults to <kernel-name>-jupyter-kernel.",
    )
    parser.add_argument(
        "--kernels-dir",
        help="Parent kernelspec directory; defaults to the user-level Jupyter kernels dir.",
    )
    parser.add_argument(
        "--repl-bin",
        help="Optional path to the project-specific repl executable; its parent is prepended to PATH.",
    )
    parser.add_argument(
        "--extra-path",
        action="append",
        default=[],
        help="Additional PATH entry to prepend. Can be passed multiple times.",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Print planned files and JSON without writing anything.",
    )
    return parser


def main() -> int:
    """Register the kernelspec and launcher."""
    args = build_parser().parse_args()
    project_root = resolve_existing_dir(args.project_root, "--project-root")
    venv_dir = Path(args.venv).expanduser()
    if not venv_dir.is_absolute():
        venv_dir = project_root / venv_dir
    venv_dir = resolve_existing_dir(str(venv_dir), "--venv")
    python = resolve_python(venv_dir, args.python)

    venv_bin = venv_dir / ("Scripts" if platform.system() == "Windows" else "bin")
    repl_default = project_root / ".lake" / "packages" / "repl" / ".lake" / "build" / "bin"
    elan_bin = Path.home() / ".elan" / "bin"

    extra_path_entries = [venv_bin]
    if args.repl_bin:
        repl_bin = Path(args.repl_bin).expanduser().resolve()
        if not repl_bin.exists():
            raise SystemExit(f"--repl-bin does not exist: {repl_bin}")
        extra_path_entries.append(repl_bin.parent)
    elif repl_default.is_dir():
        extra_path_entries.append(repl_default)
    if elan_bin.is_dir():
        extra_path_entries.append(elan_bin)
    extra_path_entries.extend(Path(path).expanduser().resolve() for path in args.extra_path)

    launcher_name = args.launcher_name or f"{args.kernel_name}-jupyter-kernel"
    launcher_path = venv_bin / launcher_name
    kernels_dir = Path(args.kernels_dir).expanduser().resolve() if args.kernels_dir else default_kernels_dir()
    kernel_dir = kernels_dir / args.kernel_name
    kernel_json_path = kernel_dir / "kernel.json"

    kernel_data = {
        "argv": [str(launcher_path), "-f", "{connection_file}"],
        "display_name": args.display_name,
        "language": "lean4",
    }

    launcher = launcher_text(project_root, python, extra_path_entries)
    write_launcher(launcher_path, launcher, args.dry_run)
    write_kernel_json(kernel_json_path, kernel_data, args.dry_run)

    print(f"Launcher: {launcher_path}")
    print(f"Kernel JSON: {kernel_json_path}")
    print(json.dumps(kernel_data, indent=2, ensure_ascii=False))
    if args.dry_run:
        print("Dry run: no files written.")
    else:
        print("Registered. Check with: jupyter kernelspec list")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
