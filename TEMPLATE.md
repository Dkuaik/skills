# AI Skills Template Repository

This is a **generic template repository** for creating and managing AI agent skills. It's designed to be project-agnostic and customizable for any type of project or technology stack.

## What This Is

A reusable framework for:
- Creating AI agent skills (domain-specific instructions for AI coding assistants)
- Synchronizing skills across multiple project branches
- Maintaining skills with proper version control and documentation

## What This Is NOT

- **Not Prowler-specific**: This is a generic template, not tied to any particular project
- **Not company-specific**: Designed to be adapted by any team or organization
- **Not technology-locked**: Works with any tech stack (Python, Go, JavaScript, etc.)

## How to Use This Template

### For a New Project

1. **Clone this template**
   ```bash
   git clone https://github.com/your-org/skills.git my-project-skills
   cd my-project-skills
   ```

2. **Customize the README.md**
   - Replace generic skills with your project-specific skills
   - Update the description to match your project
   - Remove/modify the "Meta Skills" section as needed

3. **Create project-specific skills**
   ```bash
   mkdir skills/my-skill
   # See skills/skill-creator/SKILL.md for how to create skills
   ```

4. **Set up branch structure**
   - Keep `main` for generic/shared skills
   - Create specialized branches (e.g., `backend`, `frontend`, `devops`)
   - Use `./scripts/sync-branches.sh` to keep them in sync

5. **Sync with your AI assistant**
   ```bash
   ./setup.sh
   ```

### For Existing Projects

1. **Copy the `scripts/` directory** into your project
2. **Use `sync-branches.sh`** to keep your skill branches synchronized
3. **Adapt the `conventional-commits` skill** to your project's standards
4. **Create new skills** following the `conventional-commits` structure

## Repository Structure

```
skills/
├── README.md                          # Main documentation
├── COMMIT_GUIDE.md                   # Quick reference for commits
├── CONTRIBUTING.md                   # (Optional) Contribution guidelines
├── setup.sh                          # Setup script for AI assistants
├── setup_test.sh                     # Test setup script
│
├── scripts/
│   ├── sync-branches.sh              # Synchronize skills across branches
│   └── README.md                     # Script documentation
│
├── conventional-commits/             # Example: Generic skill
│   ├── SKILL.md
│   └── assets/
│       ├── TEMPLATES.md
│       └── CHECKLIST.md
│
├── skill-creator/                    # Meta skill: Create new skills
│   ├── SKILL.md
│   └── assets/
│
├── skill-sync/                       # Meta skill: Sync skill metadata
│   └── SKILL.md
│
└── {your-skill-name}/                # Add your own skills here
    ├── SKILL.md                      # Required: Main skill file
    ├── assets/                       # Optional: Templates, schemas, examples
    │   ├── template.py
    │   └── schema.json
    └── references/                   # Optional: Links to documentation
        └── docs.md
```

## Quick Start: Creating Your First Skill

1. **Read the template skill**
   ```bash
   cat skills/conventional-commits/SKILL.md
   ```

2. **Use the skill-creator for guidance**
   ```bash
   cat skills/skill-creator/SKILL.md
   ```

3. **Create your skill**
   ```bash
   mkdir skills/my-new-skill
   cat > skills/my-new-skill/SKILL.md << 'EOF'
   ---
   name: my-new-skill
   description: >
     What this skill teaches. Trigger: When user asks for this skill.
   license: Apache-2.0
   metadata:
     author: your-org
     version: "1.0"
     scope: [root]
     auto_invoke: "When user wants this"
   allowed-tools: Read, Write, Edit, Bash
   ---

   ## When to Use

   When to load this skill...

   ## Critical Patterns

   Important rules and patterns...
   EOF
   ```

4. **Commit and sync**
   ```bash
   git add skills/my-new-skill
   git commit -m "feat(skill): add my-new-skill"
   git push origin main
   ./scripts/sync-branches.sh
   ```

## Key Features

### ✅ Conventional Commits Skill
Learn how to write standardized git commits with:
- Type decision tree (feat, fix, docs, etc.)
- Scope guidelines
- Real-world examples
- Validation checklist

Read: `skills/conventional-commits/SKILL.md`

### ✅ Sync-Branches Script
Keep multiple branches in sync:
- Cherry-picks new commits from main
- Resolves conflicts automatically
- Supports dry-run and preview modes

Usage: `./scripts/sync-branches.sh --help`

### ✅ Metadata & Auto-invoke
Skills are automatically discovered and loaded by AI assistants based on:
- `metadata.scope` - What the skill applies to
- `metadata.auto_invoke` - When to automatically load the skill

## Branch Strategy

**Recommended approach for multi-team projects:**

```
main (generic, shared skills)
  ├── backend (main + backend-specific skills)
  ├── frontend (main + frontend-specific skills)
  ├── devops (main + infrastructure-specific skills)
  └── ai (main + AI/ML-specific skills)
```

**Synchronization:**
1. Add generic skill to `main`
2. Push to origin: `git push origin main`
3. Sync all branches: `./scripts/sync-branches.sh`
4. Each branch keeps its specialized skills while getting generic updates

## Customization

### Update Commit Standards
Edit: `skills/conventional-commits/SKILL.md`
- Add your custom scopes
- Define your commit types
- Add project-specific rules

### Update Skill Metadata
Edit: `metadata.author` to your organization
Edit: `metadata.auto_invoke` to your trigger phrases

### Create New Skills
Follow the pattern in `conventional-commits`:
1. Create directory: `skills/{skill-name}`
2. Add `SKILL.md` with proper frontmatter
3. Add `assets/` for templates and examples
4. Add `references/` for documentation links

## Resources

- [Agent Skills Standard](https://agentskills.io) - Official spec
- [Agent Skills GitHub](https://github.com/anthropics/skills) - Examples
- [Claude Code Skills Docs](https://platform.claude.com/docs/en/agents-and-tools/agent-skills) - Implementation guide
- [Conventional Commits](https://www.conventionalcommits.org/) - Commit standard

## Contributing

(Add your contribution guidelines here)

## License

Apache-2.0 (or your license of choice)

---

**Last Updated**: Feb 18, 2026

This is a template. Customize it for your project!
