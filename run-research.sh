#!/bin/bash
# Multi-Agent Deep Research Runner
# Runs MCP Gateway research through multiple AI research agents

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR="$SCRIPT_DIR/output/agents"
PROMPT_FILE="$SCRIPT_DIR/input/research-prompt.md"

mkdir -p "$OUTPUT_DIR"

# Load .env if present
if [ -f "$SCRIPT_DIR/.env" ]; then
    set -a
    source "$SCRIPT_DIR/.env"
    set +a
fi

# Check for required API key
if [ -z "$OPENROUTER_API_KEY" ]; then
    echo "ERROR: OPENROUTER_API_KEY environment variable not set"
    exit 1
fi

# Load research prompt from file
if [ ! -f "$PROMPT_FILE" ]; then
    echo "ERROR: Research prompt file not found: $PROMPT_FILE"
    exit 1
fi

RESEARCH_PROMPT=$(cat "$PROMPT_FILE")

echo "================================================"
echo "Multi-Agent Deep Research Runner"
echo "================================================"
echo "Prompt file: $PROMPT_FILE"
echo "Output directory: $OUTPUT_DIR"
echo ""

# Generic function to run any OpenRouter model
run_model() {
    local model_id="$1"
    local output_name="$2"
    local display_name="$3"

    echo "Running $display_name..."

    ESCAPED_PROMPT=$(echo "$RESEARCH_PROMPT" | jq -Rs .)

    RESPONSE=$(curl -s https://openrouter.ai/api/v1/chat/completions \
        -H "Authorization: Bearer $OPENROUTER_API_KEY" \
        -H "Content-Type: application/json" \
        -H "HTTP-Referer: https://github.com/danielrosehill/MCP-Server-Research" \
        -d "{
            \"model\": \"$model_id\",
            \"messages\": [{\"role\": \"user\", \"content\": $ESCAPED_PROMPT}]
        }" 2>&1)

    # Check for error in response
    ERROR=$(echo "$RESPONSE" | jq -r '.error.message // empty')
    if [ -n "$ERROR" ]; then
        echo "    ERROR: $ERROR"
        echo "Error: $ERROR" > "$OUTPUT_DIR/$output_name.md"
    else
        CONTENT=$(echo "$RESPONSE" | jq -r '.choices[0].message.content // "No content returned"')
        echo "$CONTENT" > "$OUTPUT_DIR/$output_name.md"
        echo "    Saved to: $OUTPUT_DIR/$output_name.md"
    fi
}

# Function to run Parallel AI via their Task API
run_parallel_ai() {
    echo "Running Parallel AI Deep Research..."

    if [ -z "$PARALLEL_AI" ]; then
        echo "    ERROR: PARALLEL_AI API key not set in .env"
        echo "Error: PARALLEL_AI API key not set" > "$OUTPUT_DIR/parallel-ai.md"
        return
    fi

    ESCAPED_PROMPT=$(echo "$RESEARCH_PROMPT" | jq -Rs .)

    # Create deep research task
    RESPONSE=$(curl -s "https://api.parallel.ai/v1/tasks/runs" \
        -H "x-api-key: $PARALLEL_AI" \
        -H "Content-Type: application/json" \
        -d "{
            \"processor\": \"ultra\",
            \"input\": $ESCAPED_PROMPT
        }" 2>&1)

    echo "    Response: $RESPONSE"

    RUN_ID=$(echo "$RESPONSE" | jq -r '.run_id // .id // empty')

    if [ -z "$RUN_ID" ]; then
        ERROR=$(echo "$RESPONSE" | jq -r '.error // .message // .detail // "Unknown error"')
        echo "    ERROR creating task: $ERROR"
        echo "Error: $ERROR" > "$OUTPUT_DIR/parallel-ai.md"
        return
    fi

    echo "    Task created: $RUN_ID"
    echo "    Polling for results (this may take several minutes)..."

    # Poll for results
    for i in {1..60}; do
        sleep 10
        RESULT=$(curl -s "https://api.parallel.ai/v1/tasks/runs/$RUN_ID" \
            -H "x-api-key: $PARALLEL_AI" 2>&1)

        STATUS=$(echo "$RESULT" | jq -r '.status // "unknown"')

        if [ "$STATUS" = "completed" ] || [ "$STATUS" = "complete" ] || [ "$STATUS" = "succeeded" ]; then
            CONTENT=$(echo "$RESULT" | jq -r '.output // .result // .content // "No content"')
            echo "$CONTENT" > "$OUTPUT_DIR/parallel-ai.md"
            echo "    Saved to: $OUTPUT_DIR/parallel-ai.md"
            return
        elif [ "$STATUS" = "failed" ] || [ "$STATUS" = "error" ]; then
            ERROR=$(echo "$RESULT" | jq -r '.error // "Task failed"')
            echo "    ERROR: $ERROR"
            echo "Error: $ERROR" > "$OUTPUT_DIR/parallel-ai.md"
            return
        fi

        echo "    Status: $STATUS (attempt $i/60)"
    done

    echo "    ERROR: Timeout waiting for results"
    echo "Error: Timeout - run $RUN_ID may still be running. Check at https://platform.parallel.ai" > "$OUTPUT_DIR/parallel-ai.md"
}

echo ""
echo "Starting research agents (deep research models take several minutes)..."
echo ""

# Run models sequentially with progress
echo "[1/4] Perplexity Sonar Deep Research"
run_model "perplexity/sonar-deep-research" "perplexity-sonar" "Perplexity Sonar Deep Research"

echo ""
echo "[2/4] Alibaba Tongyi DeepResearch"
run_model "alibaba/tongyi-deepresearch-30b-a3b" "alibaba-deepresearch" "Alibaba Tongyi DeepResearch"

echo ""
echo "[3/4] Gemini 3 Flash"
run_model "google/gemini-3-flash-preview" "gemini-flash" "Gemini 3 Flash"

echo ""
echo "[4/4] Parallel AI Deep Research"
run_parallel_ai

echo ""
echo "================================================"
echo "Research Complete!"
echo "================================================"
echo ""
echo "Outputs saved to:"
ls -la "$OUTPUT_DIR"/*.md 2>/dev/null || echo "No outputs found"
echo ""
echo "To run Claude Code research manually:"
echo "  claude -p \"\$(cat $PROMPT_FILE)\" > $OUTPUT_DIR/claude-opus.md"
