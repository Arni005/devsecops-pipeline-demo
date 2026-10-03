import json, sys, glob, os
from collections import Counter

reports_dir = sys.argv[1]
rows = []

for path in sorted(glob.glob(os.path.join(reports_dir, "*.sarif"))):
    tool = os.path.basename(path).replace(".sarif", "")
    counts = Counter()
    try:
        with open(path) as f:
            data = json.load(f)
        for run in data.get("runs", []):
            for res in run.get("results", []):
                counts[res.get("level", "warning")] += 1
    except Exception as e:
        print(f"<!-- failed to parse {path}: {e} -->")
        continue
    rows.append((tool, counts["error"], counts["warning"], counts["note"]))

print("## Security Report\n")
print("| Tool | Errors (High/Crit) | Warnings | Notes |")
print("|------|-------------------:|---------:|------:|")
for tool, e, w, n in rows:
    print(f"| {tool} | {e} | {w} | {n} |")

total_err = sum(r[1] for r in rows)
print(f"\n**Total blocking-level findings: {total_err}**")
