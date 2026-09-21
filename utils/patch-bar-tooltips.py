#!/usr/bin/env python3
"""Enable shell.json tooltips on Omarchy bar plugins that ignore them by default."""

from __future__ import annotations

import json
import re
import subprocess
import sys
from pathlib import Path

HOME = Path.home()
PLUGINS = HOME / ".config/omarchy/plugins"

PATCHES = [
    ("omarchy.audio", "Audio\n\nLeft: panel · Right: mute · Scroll: volume", "Panel.qml", "BarIconButton"),
    ("omarchy.network", "Network\n\nLeft: Wi-Fi panel", "Panel.qml", "BarIconButton"),
    ("omarchy.bluetooth", "Bluetooth\n\nLeft: devices · Right: toggle radio", "Panel.qml", "BarIconButton"),
    ("omarchy.power", "Power & battery\n\nLeft: panel · Right: toggle percentage", "Panel.qml", "BarIconButton"),
    ("omarchy.monitor", "Display\n\nLeft: panel · Scroll: brightness", "Panel.qml", "BarIconButton"),
    ("omarchy.agents", "AI agents\n\nLeft: usage · Right: launch · Middle: next provider", "Panel.qml", "BarIconButton"),
    ("omarchy.clock", "Clock\n\nLeft: calendar · Right: cycle format · Middle: timezone", "BarWidget.qml", "WidgetButton"),
    ("omarchy.weather", "Weather\n\nLeft: forecast · Right: notification · Middle: refresh", "BarWidget.qml", "BarIconButton"),
]

ORPHAN_TOOLTIP_RE = re.compile(r"^\s*Left:.*\"\)\s*$", re.MULTILINE)
TOOLTIP_RE = re.compile(r"^\s*tooltipText:.*$", re.MULTILINE)


def clone_name(source_id: str) -> str:
    user = HOME.name or "user"
    return f"{user}.{source_id.removeprefix('omarchy.')}"


def ensure_clone(source_id: str) -> Path:
    target = PLUGINS / clone_name(source_id)
    if target.exists():
        return target

    subprocess.run(
        ["omarchy", "plugin", "clone", source_id],
        check=False,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )
    if not target.exists():
        raise RuntimeError(f"failed to clone {source_id}")
    return target


def tooltip_line(default_tooltip: str) -> str:
    encoded = json.dumps(default_tooltip)
    return f'    tooltipText: root.setting("tooltip", {encoded})'


def widget_block_bounds(text: str, widget: str) -> tuple[int, int]:
    marker = f"{widget} {{"
    idx = text.find(marker)
    if idx == -1:
        raise RuntimeError(f"{widget} block not found")

    pos = idx + len(marker)
    depth = 1
    while pos < len(text) and depth > 0:
        ch = text[pos]
        if ch == "{":
            depth += 1
        elif ch == "}":
            depth -= 1
        pos += 1

    return idx, pos


def patch_file(path: Path, widget: str, default_tooltip: str) -> bool:
    text = path.read_text()
    cleaned = ORPHAN_TOOLTIP_RE.sub("", text)
    start, end = widget_block_bounds(cleaned, widget)
    block = cleaned[start:end]
    desired = tooltip_line(default_tooltip)

    if TOOLTIP_RE.search(block):
        new_block = TOOLTIP_RE.sub(lambda _match: desired, block, count=1)
    else:
        insert_at = block.find("\n") + 1
        new_block = block[:insert_at] + desired + "\n" + block[insert_at:]

    if new_block == block and cleaned == text:
        return False

    updated = cleaned[:start] + new_block + cleaned[end:]
    path.write_text(updated)
    return True


def main() -> int:
    changed = 0
    for source_id, default, rel_path, widget in PATCHES:
        plugin_dir = ensure_clone(source_id)
        target = plugin_dir / rel_path
        if not target.exists():
            print(f"skip {source_id}: missing {rel_path}", file=sys.stderr)
            continue
        if patch_file(target, widget, default):
            changed += 1
            print(f"patched {target}")

    if changed:
        subprocess.run(["omarchy-shell", "shell", "rescanPlugins"], check=False)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
