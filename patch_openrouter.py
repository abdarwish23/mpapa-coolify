"""Patch main.py to support OpenRouter API key in health check."""
import pathlib
import sys

main_py = pathlib.Path("/app/src/patent_system/main.py")
content = main_py.read_text()

# 1. Update function signature
content = content.replace(
    'def check_lm_studio_connectivity(base_url: str, timeout: float = 5.0) -> bool:',
    'def check_lm_studio_connectivity(base_url: str, api_key: str = "", timeout: float = 5.0) -> bool:',
)

# 2. Add Authorization header before the urlopen call
content = content.replace(
    '        req = urllib.request.Request(url, method="GET")\n        with urllib.request.urlopen(req, timeout=timeout):',
    '        req = urllib.request.Request(url, method="GET")\n        if api_key and api_key != "not-needed":\n            req.add_header("Authorization", f"Bearer {api_key}")\n        with urllib.request.urlopen(req, timeout=timeout):',
)

# 3. Pass api_key at the call site
content = content.replace(
    '    lm_studio_reachable = check_lm_studio_connectivity(\n        settings.lm_studio_base_url,\n    )',
    '    lm_studio_reachable = check_lm_studio_connectivity(\n        settings.lm_studio_base_url,\n        api_key=settings.lm_studio_api_key,\n    )',
)

main_py.write_text(content)
print("Patched main.py successfully")
