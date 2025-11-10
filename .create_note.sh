=!/bin/bash
# Simple Linux learning note generator
# Usage: ./create_note.sh <folder> "<note-title>"

if [ $# -lt 2 ]; then
	echo "Usage: $0 <folder> \"<note title>\""
	exit 1
fi

FOLDER=$1
TITLE=$2
DATE=$(date +"%Y-%m-%d")
SLUG=$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd 'a-z0-9-')
FILE="${FOLDER}/${DATE}-${SLUG}.md"

# Ensure folder exists
mkdir -p "$FOLDER"

# Create the Markdown file
cat <<EOF > "$FILE"
# ${TITLE}

*Date:* ${DATE}

## Overview
(Brief summary of what this note covers.)

## Key Commands
\`\`\`bash
# Add commands you practiced here
\`\`\`

## Insights
(Write key takeaways or small realizations.)

## Reflection
> (One sentence about what was most interesting or confusing.)
EOF

echo "Created note: ${FILE}"

nano "$FILE"

git add "$FILE"
git commit -m "Added note: ${TITLE}"
git push
echo "Committed and pushed: ${TITLE}"
