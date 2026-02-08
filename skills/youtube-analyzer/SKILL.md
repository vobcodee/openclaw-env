---
name: youtube-analyzer
description: Analyze YouTube videos by extracting transcripts and creating detailed chapter-by-chapter breakdowns. Use when the user needs to (1) Extract and analyze YouTube video content, (2) Create structured summaries of educational/interview videos, (3) Generate actionable insights from video content, or (4) Build a knowledge base from YouTube videos for future reference.
---

# YouTube Video Analyzer

## Overview

This skill extracts transcripts from YouTube videos and creates comprehensive chapter-by-chapter analyses including key insights, quotes, and actionable items.

## Prerequisites

- `yt-dlp` installed (will be auto-installed if missing)
- `python3` available

## Quick Start

### 1. Extract Transcript

```bash
export PATH="$HOME/.local/bin:$PATH"
python3 /root/clawd/skills/youtube-analyzer/scripts/analyze.py "https://www.youtube.com/watch?v=VIDEO_ID"
```

### 2. Full Analysis Workflow

```bash
bash /root/clawd/skills/youtube-analyzer/scripts/full-analysis.sh "YOUTUBE_URL" "OUTPUT_DIR"
```

This will:
1. Extract transcript
2. Create outline
3. Generate chapter analyses (auto-detected or specified)
4. Compile quotes collection
5. Create action items
6. Generate summary
7. Package everything

## Manual Process

If you need more control, follow these steps:

### Step 1: Get Transcript
```bash
yt-dlp --write-subs --sub-langs en --skip-download "URL" -o /tmp/transcript
```

### Step 2: Analyze Structure
Read the transcript and identify:
- Number of chapters/topics
- Key themes
- Natural break points

### Step 3: Create Chapter Analyses
For each chapter:
- Extract key concepts (3-5 items)
- Find memorable quotes (2-3 quotes)
- Create structured tables
- Identify actionable insights

### Step 4: Compile Outputs
- Quotes collection (categorized)
- Action items (immediate/short-term/long-term)
- Executive summary (1-page)

### Step 5: Package
```bash
cd /root/clawd/memory
tar -czf youtube-analysis-$(date +%Y%m%d).tar.gz youtube-*.md
```

## Output Structure

```
output/
├── youtube-transcript-outline.md      # Video structure/outline
├── youtube-chapter1-analysis.md       # Chapter 1 detailed analysis
├── youtube-chapter2-analysis.md       # Chapter 2 detailed analysis
├── ...
├── youtube-chapterN-analysis.md       # Chapter N detailed analysis
├── youtube-quotes-collection.md       # Categorized key quotes
├── youtube-action-items.md            # Actionable takeaways
└── youtube-summary.md                 # One-page executive summary
```

## Analysis Framework

### For Each Chapter:
1. **Key Summary** - 3-5 bullet points
2. **Memorable Quotes** - 2-3 direct quotes with attribution
3. **Structured Tables** - Concepts, comparisons, frameworks
4. **Real Examples** - Case studies from the video
5. **Key Insights** - Actionable takeaways

### Quality Checklist:
- [ ] Core concepts identified (3-5 per chapter)
- [ ] Quotes extracted (2-3 per chapter)
- [ ] Tables used for structure
- [ ] Real examples included (where applicable)
- [ ] Actionable insights derived

## Tips

- **Speed**: For long videos, focus on key chapters first
- **Depth**: Adjust detail level based on video importance
- **Quotes**: Always attribute quotes to speakers
- **Tables**: Use tables for comparisons and frameworks
- **Actions**: Make action items specific and time-bound

## Example Usage

```bash
# Quick transcript only
bash /root/clawd/skills/youtube-analyzer/scripts/analyze.sh "https://youtube.com/watch?v=ABC123"

# Full analysis with custom chapter count
bash /root/clawd/skills/youtube-analyzer/scripts/full-analysis.sh "URL" "/output/dir" 10
```

## Notes

- Transcript quality depends on video captions
- Auto-generated captions may have errors
- For best results, videos with manual captions preferred
- Analysis time: ~10-15 minutes per 10-minute video segment