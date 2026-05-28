#!/usr/bin/env bash
# check-governance.sh
# Detect common governance-asset problems in a project that uses the constitution skill.
#
# Checks performed:
#   1. AGENTS.md presence when CLAUDE.md or .cursor/rules exist (avoid orphan adapters).
#   2. Required sections present in each TASKS/*.md file.
#   3. Required sections present in SPEC.md, ARCH.md, RULES.md.
#   4. Contract files referenced by ARCH.md/RULES.md actually exist.
#   5. Significant duplication between AGENTS.md, CLAUDE.md, .cursor/rules/*, .claude/rules/*.
#   6. TASKS that lack `## Verification` or `## Acceptance Criteria`.
#   7. Files marked `Status: Active` whose `Last Reviewed` is older than 180 days.
#
# Exit code: 0 if no issues, 1 if any issue is reported.
#
# Usage:
#   scripts/check-governance.sh              # run in current repo root
#   scripts/check-governance.sh path/to/repo

set -u

ROOT="${1:-.}"
if [ ! -d "$ROOT" ]; then
    printf "error: '%s' is not a directory\n" "$ROOT" >&2
    exit 2
fi

cd "$ROOT" || exit 2

ISSUES=0
WARNINGS=0

c_red=$(printf '\033[31m')
c_yel=$(printf '\033[33m')
c_grn=$(printf '\033[32m')
c_rst=$(printf '\033[0m')

report_error() {
    printf "%sERROR%s  %s\n" "$c_red" "$c_rst" "$1"
    ISSUES=$((ISSUES + 1))
}

report_warn() {
    printf "%sWARN%s   %s\n" "$c_yel" "$c_rst" "$1"
    WARNINGS=$((WARNINGS + 1))
}

report_ok() {
    printf "%sOK%s     %s\n" "$c_grn" "$c_rst" "$1"
}

# 1. Adapter orphans -----------------------------------------------------------

has_agents=0
[ -f "AGENTS.md" ] && has_agents=1

has_claude=0
[ -f "CLAUDE.md" ] && has_claude=1

has_cursor_rules=0
if [ -d ".cursor/rules" ] && ls .cursor/rules/*.mdc >/dev/null 2>&1; then
    has_cursor_rules=1
fi

has_claude_rules=0
if [ -d ".claude/rules" ] && ls .claude/rules/*.md >/dev/null 2>&1; then
    has_claude_rules=1
fi

if [ "$has_agents" -eq 0 ] && { [ "$has_claude" -eq 1 ] || [ "$has_cursor_rules" -eq 1 ] || [ "$has_claude_rules" -eq 1 ]; }; then
    report_error "Tool adapter files exist (CLAUDE.md / .cursor/rules / .claude/rules) but AGENTS.md is missing. Add a canonical AGENTS.md."
fi

# 2. TASKS sections ------------------------------------------------------------

TASK_DIRS="docs/TASKS TASKS"
TASK_REQUIRED="^## Goal$ ^## Scope$ ^## Acceptance Criteria$ ^## Verification$"

for dir in $TASK_DIRS; do
    if [ -d "$dir" ]; then
        for f in "$dir"/*.md; do
            [ -e "$f" ] || continue
            missing=""
            for pat in $TASK_REQUIRED; do
                if ! grep -Eq "$pat" "$f"; then
                    missing="$missing $(printf '%s' "$pat" | tr -d '^$')"
                fi
            done
            if [ -n "$missing" ]; then
                report_error "$f missing sections:$missing"
            fi
        done
    fi
done

# 3. Required sections in SPEC/ARCH/RULES --------------------------------------

check_required_sections() {
    file="$1"
    shift
    if [ ! -f "$file" ]; then
        return 0
    fi
    missing=""
    for sec in "$@"; do
        if ! grep -Eq "^## $sec$" "$file"; then
            missing="$missing '$sec'"
        fi
    done
    if [ -n "$missing" ]; then
        report_error "$file missing sections:$missing"
    fi
}

for spec_path in docs/SPEC.md SPEC.md; do
    [ -f "$spec_path" ] || continue
    check_required_sections "$spec_path" \
        "Product Intent" "Users" "Goals" "Non-Goals" "Acceptance Criteria"
done

for arch_path in docs/ARCH.md ARCH.md; do
    [ -f "$arch_path" ] || continue
    check_required_sections "$arch_path" \
        "Architecture Summary" "Module Boundaries" "Dependency Rules"
done

for rules_path in docs/RULES.md RULES.md; do
    [ -f "$rules_path" ] || continue
    check_required_sections "$rules_path" \
        "Coding Rules" "Testing Rules" "Security And Safety Rules"
done

# 4. Contract files referenced from ARCH.md / RULES.md must exist --------------

for ref_file in docs/ARCH.md docs/RULES.md ARCH.md RULES.md; do
    [ -f "$ref_file" ] || continue
    # Match links like `docs/CONTRACTS/whatever.yaml` or `CONTRACTS/whatever.md`
    refs=$(grep -Eo '(docs/)?CONTRACTS/[A-Za-z0-9._/-]+' "$ref_file" | sort -u)
    for r in $refs; do
        if [ ! -e "$r" ]; then
            report_warn "$ref_file references missing contract: $r"
        fi
    done
done

# 5. Duplication between AGENTS.md, CLAUDE.md, .cursor/rules/, .claude/rules/ ---

# Strategy: extract distinctive non-trivial lines (>= 40 chars, alphabetic) from
# each file, sort+unique, then look for cross-file overlap above a threshold.

dup_inputs=""
for f in AGENTS.md CLAUDE.md; do
    [ -f "$f" ] && dup_inputs="$dup_inputs $f"
done
if [ "$has_cursor_rules" -eq 1 ]; then
    for f in .cursor/rules/*.mdc; do
        [ -e "$f" ] && dup_inputs="$dup_inputs $f"
    done
fi
if [ "$has_claude_rules" -eq 1 ]; then
    for f in .claude/rules/*.md; do
        [ -e "$f" ] && dup_inputs="$dup_inputs $f"
    done
fi

if [ -n "$dup_inputs" ]; then
    tmp_all=$(mktemp)
    trap 'rm -f "$tmp_all"' EXIT
    for f in $dup_inputs; do
        awk -v path="$f" 'NF >= 1 {
            line = $0
            gsub(/^[ \t]+|[ \t]+$/, "", line)
            if (length(line) >= 40 && line !~ /^#/ && line !~ /^---/ && line !~ /^@/) {
                print path "\t" line
            }
        }' "$f"
    done > "$tmp_all"

    # Find lines appearing in 2+ files
    dup_lines=$(awk -F'\t' '{ count[$2]++; files[$2] = files[$2] " " $1 }
        END {
            for (l in count) {
                if (count[l] >= 2) {
                    n = split(files[l], parts, " ")
                    delete seen
                    distinct = 0
                    for (i = 1; i <= n; i++) {
                        if (parts[i] != "" && !(parts[i] in seen)) {
                            seen[parts[i]] = 1
                            distinct++
                        }
                    }
                    if (distinct >= 2) {
                        printf "%d\t%s\n", distinct, l
                    }
                }
            }
        }' "$tmp_all" | sort -nr | head -n 5)

    if [ -n "$dup_lines" ]; then
        report_warn "Repeated lines across adapter files (top 5). Consider keeping AGENTS.md canonical:"
        printf "%s\n" "$dup_lines" | while IFS=$(printf '\t') read -r n line; do
            printf "         in %s files: %s\n" "$n" "$line"
        done
    fi
fi

# 6. (covered by check 2)

# 7. Last-reviewed staleness ---------------------------------------------------

now_epoch=$(date +%s)
stale_threshold=$((180 * 24 * 60 * 60))

scan_for_stale() {
    for f in "$@"; do
        [ -f "$f" ] || continue
        last=$(grep -E '^Last Reviewed:' "$f" | head -n 1 | sed -E 's/^Last Reviewed:[[:space:]]*//')
        status=$(grep -E '^Status:' "$f" | head -n 1 | sed -E 's/^Status:[[:space:]]*//')
        [ -z "$last" ] && continue
        case "$status" in
            Active|active|"") ;;
            *) continue ;;
        esac
        # Try GNU date first, fall back to BSD date
        if last_epoch=$(date -d "$last" +%s 2>/dev/null); then
            :
        elif last_epoch=$(date -j -f "%Y-%m-%d" "$last" +%s 2>/dev/null); then
            :
        else
            continue
        fi
        age=$((now_epoch - last_epoch))
        if [ "$age" -gt "$stale_threshold" ]; then
            days=$((age / 86400))
            report_warn "$f Last Reviewed is $days days old (>180); consider re-reviewing."
        fi
    done
}

scan_for_stale \
    AGENTS.md CLAUDE.md \
    docs/SPEC.md docs/ARCH.md docs/RULES.md \
    SPEC.md ARCH.md RULES.md
if [ -d "docs/DECISIONS" ]; then
    # shellcheck disable=SC2046
    scan_for_stale $(ls docs/DECISIONS/*.md 2>/dev/null)
fi
if [ -d "docs/CONTRACTS" ]; then
    # shellcheck disable=SC2046
    scan_for_stale $(ls docs/CONTRACTS/*.md 2>/dev/null)
fi

# Summary ----------------------------------------------------------------------

printf "\n"
if [ "$ISSUES" -eq 0 ] && [ "$WARNINGS" -eq 0 ]; then
    report_ok "Governance check passed."
    exit 0
fi

printf "Issues: %d  Warnings: %d\n" "$ISSUES" "$WARNINGS"
if [ "$ISSUES" -gt 0 ]; then
    exit 1
fi
exit 0
