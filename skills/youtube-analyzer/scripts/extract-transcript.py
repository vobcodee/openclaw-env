#!/usr/bin/env python3
"""
Extract transcript from YouTube video using yt-dlp
"""

import sys
import subprocess
import os

def extract_transcript(url):
    """Extract transcript from YouTube URL"""
    
    # Ensure yt-dlp is in PATH
    os.environ['PATH'] = os.path.expanduser('~/.local/bin') + ':' + os.environ.get('PATH', '')
    
    try:
        # Try to get transcript
        result = subprocess.run(
            ['yt-dlp', '--write-subs', '--sub-langs', 'en', '--skip-download', 
             '--print', 'filename', '-o', '%(title)s', url],
            capture_output=True,
            text=True,
            timeout=60
        )
        
        if result.returncode == 0:
            print(f"Video: {result.stdout.strip()}")
            print("Transcript extraction initiated...")
            return True
        else:
            print(f"Error: {result.stderr}", file=sys.stderr)
            return False
            
    except Exception as e:
        print(f"Error extracting transcript: {e}", file=sys.stderr)
        return False

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: extract-transcript.py <youtube_url>")
        sys.exit(1)
    
    url = sys.argv[1]
    success = extract_transcript(url)
    sys.exit(0 if success else 1)
