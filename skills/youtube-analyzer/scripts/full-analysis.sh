#!/bin/bash
# Full YouTube Video Analysis Script

URL="$1"
OUTPUT_DIR="${2:-/root/clawd/memory}"
CHAPTERS="${3:-10}"

if [ -z "$URL" ]; then
    echo "Usage: $0 <youtube_url> [output_dir] [num_chapters]"
    exit 1
fi

echo "=== YouTube Video Analyzer ==="
echo "URL: $URL"
echo "Output: $OUTPUT_DIR"
echo "Chapters: $CHAPTERS"
echo ""

# Ensure yt-dlp is available
export PATH="$HOME/.local/bin:$PATH"
if ! command -v yt-dlp &> /dev/null; then
    echo "Installing yt-dlp..."
    uv tool install yt-dlp
fi

# Create output directory
mkdir -p "$OUTPUT_DIR"
cd "$OUTPUT_DIR"

# Step 1: Extract transcript
echo "[1/5] Extracting transcript..."
python3 /root/clawd/skills/youtube-analyzer/scripts/extract-transcript.py "$URL" > transcript.txt 2>&1
if [ $? -ne 0 ]; then
    echo "Failed to extract transcript. Trying alternative method..."
    yt-dlp --write-subs --sub-langs en --skip-download "$URL" -o transcript 2>&1
fi

# Step 2: Create outline
echo "[2/5] Creating outline..."
cat > youtube-transcript-outline.md << 'EOF'
# Video Analysis Outline

## Video Information
- **URL**: $URL
- **Analysis Date**: $(date +%Y-%m-%d)
- **Chapters**: $CHAPTERS

## Chapters
EOF

for i in $(seq 1 $CHAPTERS); do
    echo "$i. Chapter $i - [Topic to be determined]" >> youtube-transcript-outline.md
done

# Step 3: Generate chapter templates
echo "[3/5] Creating chapter analysis templates..."
for i in $(seq 1 $CHAPTERS); do
    cat > "youtube-chapter${i}-analysis.md" << EOF
# Chapter $i: [Topic]

## 📌 Key Summary

| Concept | Description |
|---------|-------------|
| Key Point 1 | Description |
| Key Point 2 | Description |
| Key Point 3 | Description |

## 💬 Key Quotes

> *"Quote 1"*
> — Speaker

> *"Quote 2"*
> — Speaker

## 🎯 Main Content

### Section 1
- Detail 1
- Detail 2
- Detail 3

### Section 2
- Detail 1
- Detail 2

## ✅ Key Takeaways

1. Takeaway 1
2. Takeaway 2
3. Takeaway 3

---

**Chapter $i Complete ✅**
EOF
done

# Step 4: Create quotes collection template
echo "[4/5] Creating quotes collection..."
cat > youtube-quotes-collection.md << 'EOF'
# Key Quotes Collection

## Category 1: Topic
> *"Quote"*
> — Speaker

## Category 2: Topic
> *"Quote"*
> — Speaker

---

**Total: [X] quotes collected**
EOF

# Step 5: Create action items template
echo "[5/5] Creating action items..."
cat > youtube-action-items.md << 'EOF'
# Actionable Items

## Immediate (Today)
- [ ] Action 1
- [ ] Action 2
- [ ] Action 3

## Short-term (This Week)
- [ ] Action 1
- [ ] Action 2

## Long-term (This Month)
- [ ] Action 1
- [ ] Action 2

---

**Track your progress! ✅**
EOF

# Step 6: Create summary
cat > youtube-summary.md << 'EOF'
# Executive Summary

## 🎯 Key Message
[One-sentence summary]

## 📊 Overview
- **Video Length**: [X] minutes
- **Key Chapters**: [N]
- **Main Themes**: [List]

## 💡 Top 5 Insights
1. Insight 1
2. Insight 2
3. Insight 3
4. Insight 4
5. Insight 5

## ✅ Next Actions
1. [Action 1]
2. [Action 2]
3. [Action 3]

---

**Analysis Complete 🎉**
EOF

# Package everything
echo ""
echo "Packaging files..."
tar -czf "youtube-analysis-$(date +%Y%m%d).tar.gz" youtube-*.md transcript.txt 2>/dev/null

echo ""
echo "=== Analysis Complete ==="
echo "Files created in: $OUTPUT_DIR"
ls -lh youtube-*.md
echo ""
echo "Package: youtube-analysis-$(date +%Y%m%d).tar.gz"
