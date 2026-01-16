# AI-Enforced Conventions Example

This repository demonstrates how to use AI agents with MCP (Model Context Protocol) to automatically enforce naming conventions and style guides in your CI/CD pipeline.

**Read the full article:** [Stop Being the Naming Convention Police](https://blog.daana.dev/blog/stop-being-naming-convention-police)

## The Idea

Instead of:
- Writing and maintaining linter rules
- Keeping documentation and enforcement in sync
- Being the "naming convention police" yourself

Let AI read your living documentation and enforce it automatically.

## What's in This Repo

```
├── docs/
│   ├── metric-naming-convention.md  # Copy to Notion
│   └── sql-style-guide.md           # Copy to Notion
├── samples/
│   ├── metrics_with_violations.yml  # Test file with violations
│   └── orders_summary_with_violations.sql
├── prompts/
│   └── review-conventions.md        # Agent prompt
├── .github/workflows/
│   └── convention-review.yml        # GitHub Action
└── mcp-config.example.json          # MCP configuration
```

## Quick Start

### 1. Set Up Notion Pages

Create two pages in Notion and copy the content from `docs/`:
- Metric Naming Convention
- SQL Style Guide

Note the page IDs from the URLs (the 32-character hex string).

### 2. Create Notion Integration

1. Go to [notion.so/my-integrations](https://www.notion.so/my-integrations)
2. Create a new integration
3. Copy the token (starts with `ntn_`)
4. Connect the integration to your pages (Page → ... → Add connections)

### 3. Add GitHub Secrets

In your repo settings, add:
- `ANTHROPIC_API_KEY`: Your Anthropic API key
- `NOTION_TOKEN`: Your Notion integration token

### 4. Update Page IDs

Edit `.github/workflows/convention-review.yml` and update the Notion page IDs to match your pages.

### 5. Test It

1. Create a branch
2. Add a SQL file or metrics file with violations
3. Open a PR
4. Watch the AI review it

## How It Works

```
PR opened → GitHub Action triggers → Claude Code runs →
Fetches conventions from Notion via MCP → Reviews changed files →
Posts violations as PR comment
```

The key insight: **your documentation becomes executable**. Update the Notion page, and the next PR automatically follows the new rules.

## Try It Locally

```bash
# Install Claude Code
npm install -g @anthropic-ai/claude-code

# Add Notion MCP
claude mcp add notion -e "NOTION_TOKEN=your_token" -- npx -y @notionhq/notion-mcp-server

# Run review on a file
claude "Review samples/metrics_with_violations.yml against the Metric Naming Convention in Notion page 2eab84e92e7780029a3de4be7927d0f0"
```

## Example Output

When the agent reviews `samples/metrics_with_violations.yml`:

```
VIOLATION: metrics_with_violations.yml:5 `total_revenue`
- Issue: Contains forbidden scope word "total"
- Standard: "Words like total, sum, avg should NOT appear in metric names"
- Suggested fix: `revenue_amount`
- Severity: Critical

VIOLATION: metrics_with_violations.yml:11 `nbr_of_paid_subs`
- Issue: Uses abbreviation and wrong structure
- Standard: "All metric names follow: <entity>_<descriptor>_<unit>"
- Suggested fix: `subscriptions_paid_count`
- Severity: Critical

...

## Summary
Files reviewed: 1
Violations found: 6
- Critical: 3
- Medium: 2
- Minor: 1

Recommendation: REQUEST_CHANGES
```

## Customizing

### Different Documentation Platform

Replace Notion MCP with your platform:
- Confluence: Use Atlassian MCP
- Google Docs: Use Google MCP
- Local files: Skip MCP, reference files directly

### Different Conventions

1. Create your own convention documents
2. Update the page IDs in the workflow
3. Adjust the prompt in `prompts/review-conventions.md`

### Severity Levels

Edit the prompt to change what's Critical vs Medium vs Minor based on your team's priorities.

## Limitations

- **Non-deterministic**: AI may interpret rules slightly differently each time
- **Latency**: AI review takes longer than regex linting
- **Cost**: API calls have associated costs
- **Not a replacement for all linting**: Use traditional linters for deterministic rules

## Resources

- [MCP Documentation](https://modelcontextprotocol.io)
- [Notion MCP Server](https://github.com/makenotion/notion-mcp-server)
- [Claude Code Action](https://github.com/anthropics/claude-code-action)
- [Full Article](https://blog.daana.dev/blog/stop-being-naming-convention-police)

## License

MIT - Use this however you want.
