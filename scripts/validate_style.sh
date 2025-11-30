#!/bin/bash
# validate_style.sh - Validate documentation style compliance
# Based on STYLE_GUIDE.md standards for the 27-Month Cybersecurity Roadmap
#
# Usage: ./scripts/validate_style.sh [--fix]
# Options:
#   --fix    Auto-fix common issues (use with caution)
#
# Exit codes:
#   0 - All checks passed
#   1 - Errors found

set -e

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

ERRORS=0
WARNINGS=0

# Get script directory and repo root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}       27-Month Roadmap Documentation Style Validator           ${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo ""

# Change to repo root
cd "$REPO_ROOT"

#############################################################################
# CHECK 1: File naming conventions
#############################################################################
echo -e "${BLUE}[CHECK 1] File Naming Conventions${NC}"
echo "────────────────────────────────────────────"

# Root level files should be CAPS_WITH_UNDERSCORES.md
for file in *.md; do
    if [[ -f "$file" ]]; then
        if [[ ! "$file" =~ ^[A-Z][A-Z_]+\.md$ ]] && [[ "$file" != "README.md" ]]; then
            echo -e "  ${YELLOW}WARNING${NC}: $file - Root files should be CAPS_WITH_UNDERSCORES.md"
            ((WARNINGS++))
        fi
    fi
done

# Check subdirectory files
for dir in roadmap docs templates examples; do
    if [[ -d "$dir" ]]; then
        for file in "$dir"/*.md; do
            if [[ -f "$file" ]]; then
                basename=$(basename "$file")
                if [[ ! "$basename" =~ ^[A-Z][A-Z0-9_-]+\.md$ ]] && [[ "$basename" != "README.md" ]]; then
                    echo -e "  ${YELLOW}WARNING${NC}: $file - Should be CAPS_WITH_UNDERSCORES.md"
                    ((WARNINGS++))
                fi
            fi
        done
    fi
done

echo -e "  ${GREEN}✓${NC} File naming check complete"
echo ""

#############################################################################
# CHECK 2: Version footers
#############################################################################
echo -e "${BLUE}[CHECK 2] Version Footers${NC}"
echo "────────────────────────────────────────────"

# Find markdown files without "Last Updated"
for file in *.md roadmap/*.md docs/*.md templates/*.md examples/*.md; do
    if [[ -f "$file" ]]; then
        # Skip archive files
        if [[ "$file" == *"/archive/"* ]]; then
            continue
        fi

        if ! grep -q "Last Updated" "$file"; then
            echo -e "  ${RED}ERROR${NC}: $file - Missing version footer"
            ((ERRORS++))
        fi
    fi
done 2>/dev/null

echo -e "  ${GREEN}✓${NC} Version footer check complete"
echo ""

#############################################################################
# CHECK 3: Terminology consistency
#############################################################################
echo -e "${BLUE}[CHECK 3] Terminology Consistency${NC}"
echo "────────────────────────────────────────────"

# Check for "light month" instead of "recovery month" (exclude STYLE_GUIDE.md which has examples)
if grep -rn --include="*.md" "light month" . 2>/dev/null | grep -v "STYLE_GUIDE.md"; then
    echo -e "  ${RED}ERROR${NC}: Use 'recovery month' not 'light month'"
    ((ERRORS++))
fi

# Check for "break month" (exclude STYLE_GUIDE.md which has examples)
if grep -rn --include="*.md" "break month" . 2>/dev/null | grep -v "STYLE_GUIDE.md"; then
    echo -e "  ${RED}ERROR${NC}: Use 'recovery month' not 'break month'"
    ((ERRORS++))
fi

# Check for lowercase "cyberark" (exclude URLs, service accounts, Docker images, config values)
cyberark_issues=$(grep -rn --include="*.md" "[^A-Za-z_/:]cyberark[^A-Za-z_/.\-:]" . 2>/dev/null | \
    grep -v "cyberark.com\|cyberark.force\|svc_cyberark\|cyberark/\|github.com.*cyberark\|sourcetype:\|STYLE_GUIDE" | head -5)
if [[ -n "$cyberark_issues" ]]; then
    echo "$cyberark_issues"
    echo -e "  ${YELLOW}WARNING${NC}: Use 'CyberArk' (capital A) not 'cyberark'"
    ((WARNINGS++))
fi

# Check for lowercase "kubernetes" in prose (exclude URLs, examples in style guide, subreddit names)
k8s_issues=$(grep -rn --include="*.md" "[^A-Za-z/]kubernetes[^.io]" . 2>/dev/null | \
    grep -v "\.k8s\|kubernetes.io\|kubernetes-\|STYLE_GUIDE\|r/kubernetes" | head -5)
if [[ -n "$k8s_issues" ]]; then
    echo "$k8s_issues"
    echo -e "  ${YELLOW}WARNING${NC}: Use 'Kubernetes' (capital K) in prose"
    ((WARNINGS++))
fi

echo -e "  ${GREEN}✓${NC} Terminology check complete"
echo ""

#############################################################################
# CHECK 4: Link validation
#############################################################################
echo -e "${BLUE}[CHECK 4] Internal Link Validation${NC}"
echo "────────────────────────────────────────────"

# Check for broken internal .md links (skip STYLE_GUIDE.md which has example links)
for file in *.md roadmap/*.md docs/*.md templates/*.md examples/*.md; do
    if [[ -f "$file" ]] && [[ "$file" != "STYLE_GUIDE.md" ]]; then
        # Extract markdown links to .md files
        while IFS= read -r link; do
            # Get the path relative to the file's directory
            file_dir=$(dirname "$file")

            # Remove anchor if present
            link_path="${link%%#*}"

            # Skip external links and empty links
            if [[ "$link_path" == http* ]] || [[ -z "$link_path" ]]; then
                continue
            fi

            # Build full path
            if [[ "$link_path" == /* ]]; then
                full_path="$link_path"
            elif [[ "$link_path" == ../* ]]; then
                full_path="$file_dir/$link_path"
            else
                full_path="$file_dir/$link_path"
            fi

            # Normalize path
            full_path=$(realpath -m "$full_path" 2>/dev/null || echo "$full_path")

            # Check if file exists (skip example paths in style guide)
            if [[ "$link_path" == *.md ]] && [[ ! -f "$full_path" ]]; then
                # Skip example paths that aren't meant to be real files
                if [[ "$link_path" != *"relative/"* ]] && [[ "$link_path" != *"path/to/"* ]] && [[ "$link_path" != *"example"* ]]; then
                    echo -e "  ${YELLOW}WARNING${NC}: $file - Broken link: $link"
                    ((WARNINGS++))
                fi
            fi
        done < <(grep -oP '\]\(\K[^)]+' "$file" 2>/dev/null)
    fi
done 2>/dev/null

echo -e "  ${GREEN}✓${NC} Link validation complete"
echo ""

#############################################################################
# CHECK 5: Header hierarchy
#############################################################################
echo -e "${BLUE}[CHECK 5] Header Hierarchy${NC}"
echo "────────────────────────────────────────────"

# Check for multiple H1 headers in root files only (code blocks can have # comments)
# Skip docs/ and examples/ which have code blocks with # comments
for file in *.md roadmap/*.md; do
    if [[ -f "$file" ]] && [[ "$file" != "STYLE_GUIDE.md" ]]; then
        h1_count=$(grep -c "^# [^#]" "$file" 2>/dev/null || echo "0")
        if [[ "$h1_count" -gt 1 ]]; then
            echo -e "  ${YELLOW}WARNING${NC}: $file - Multiple H1 headers ($h1_count found)"
            ((WARNINGS++))
        fi
    fi
done 2>/dev/null

echo -e "  ${GREEN}✓${NC} Header hierarchy check complete"
echo ""

#############################################################################
# CHECK 6: Code block language identifiers
#############################################################################
echo -e "${BLUE}[CHECK 6] Code Block Language Identifiers${NC}"
echo "────────────────────────────────────────────"

# Check for code blocks without language identifier (skip STYLE_GUIDE.md examples)
# This checks for opening ``` without language identifier by looking at pairs
# Note: This is a simple check - complex cases may have false positives/negatives
for file in *.md roadmap/*.md; do
    if [[ -f "$file" ]] && [[ "$file" != "STYLE_GUIDE.md" ]]; then
        # Use awk to check code block openings
        missing_lang=$(awk '
            /^```$/ && !in_block { print NR": Opening code block without language"; in_block=1; next }
            /^```[a-z]/ { in_block=1; next }
            /^```$/ && in_block { in_block=0; next }
        ' "$file" 2>/dev/null | head -3)
        if [[ -n "$missing_lang" ]]; then
            echo "$missing_lang"
            echo -e "  ${YELLOW}WARNING${NC}: $file - Code block without language identifier"
            ((WARNINGS++))
        fi
    fi
done 2>/dev/null

echo -e "  ${GREEN}✓${NC} Code block check complete"
echo ""

#############################################################################
# CHECK 7: Date format validation
#############################################################################
echo -e "${BLUE}[CHECK 7] Date Format Validation${NC}"
echo "────────────────────────────────────────────"

# Check for incorrect date formats in Last Updated (should be YYYY-MM-DD)
# Skip STYLE_GUIDE.md which has example incorrect formats
for file in *.md roadmap/*.md docs/*.md templates/*.md examples/*.md; do
    if [[ -f "$file" ]] && [[ "$file" != "STYLE_GUIDE.md" ]]; then
        # Check for MM/DD/YYYY or DD/MM/YYYY format
        if grep -n "Last Updated.*[0-9]\{1,2\}/[0-9]\{1,2\}/[0-9]\{4\}" "$file" 2>/dev/null; then
            echo -e "  ${RED}ERROR${NC}: $file - Use YYYY-MM-DD format for dates"
            ((ERRORS++))
        fi
    fi
done 2>/dev/null

echo -e "  ${GREEN}✓${NC} Date format check complete"
echo ""

#############################################################################
# SUMMARY
#############################################################################
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}                         SUMMARY                                ${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo ""

if [[ $ERRORS -eq 0 ]] && [[ $WARNINGS -eq 0 ]]; then
    echo -e "  ${GREEN}✅ All style checks passed!${NC}"
    echo ""
    exit 0
elif [[ $ERRORS -eq 0 ]]; then
    echo -e "  ${YELLOW}⚠️  $WARNINGS warning(s) found${NC}"
    echo -e "  ${GREEN}✅ No critical errors${NC}"
    echo ""
    exit 0
else
    echo -e "  ${RED}❌ $ERRORS error(s) found${NC}"
    echo -e "  ${YELLOW}⚠️  $WARNINGS warning(s) found${NC}"
    echo ""
    echo -e "  Please fix errors before committing."
    echo -e "  See STYLE_GUIDE.md for formatting standards."
    echo ""
    exit 1
fi
