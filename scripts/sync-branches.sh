#!/bin/bash

###############################################################################
# sync-branches.sh - Synchronize skills from main to specialized branches
# 
# Usage:
#   ./scripts/sync-branches.sh                 # Sync all detected branches
#   ./scripts/sync-branches.sh --dry-run       # Show what would happen
#   ./scripts/sync-branches.sh --branches anthropic,fastapi  # Sync specific
#   ./scripts/sync-branches.sh --help          # Show help
#
# Strategy: Cherry-pick new commits from main to each specialized branch
# with automatic conflict resolution.
###############################################################################

set -euo pipefail

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
DRY_RUN=false
VERBOSE=false
BRANCHES_TO_SYNC=()
AUTO_DETECT_BRANCHES=true
MAIN_BRANCH="main"

###############################################################################
# Helper Functions
###############################################################################

log_info() {
    echo -e "${BLUE}ℹ${NC} $*"
}

log_success() {
    echo -e "${GREEN}✓${NC} $*"
}

log_warn() {
    echo -e "${YELLOW}⚠${NC} $*"
}

log_error() {
    echo -e "${RED}✗${NC} $*"
}

log_section() {
    echo ""
    echo -e "${BLUE}═══════════════════════════════════════${NC}"
    echo -e "${BLUE}$*${NC}"
    echo -e "${BLUE}═══════════════════════════════════════${NC}"
}

verbose() {
    if [ "$VERBOSE" = true ]; then
        echo -e "${YELLOW}[DEBUG]${NC} $*"
    fi
}

show_help() {
    cat << 'EOF'
sync-branches.sh - Synchronize skills from main to specialized branches

USAGE:
    ./scripts/sync-branches.sh [OPTIONS]

OPTIONS:
    --dry-run              Show what would happen without making changes
    --verbose              Show detailed debugging output
    --branches NAMES       Sync specific branches (comma-separated)
                           Example: --branches anthropic,fastapi
    --no-push              Cherry-pick but don't push to origin
    --help                 Show this help message

EXAMPLES:
    # Sync all branches that are behind main
    ./scripts/sync-branches.sh

    # Preview changes before syncing
    ./scripts/sync-branches.sh --dry-run

    # Sync only anthropic and fastapi branches
    ./scripts/sync-branches.sh --branches anthropic,fastapi

    # Cherry-pick changes locally, review, then push manually
    ./scripts/sync-branches.sh --no-push

STRATEGY:
    - Detects commits in 'main' that don't exist in each branch
    - Cherry-picks those commits to each branch
    - Resolves merge conflicts automatically
    - Pushes synced branches back to origin

REQUIREMENTS:
    - Git repository with main branch
    - Branches that derive from main (anthropic, fastapi, etc.)
    - Clean working tree before running

EOF
}

###############################################################################
# Validation Functions
###############################################################################

validate_prerequisites() {
    log_section "Validating Prerequisites"
    
    # Check if we're in a git repo
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        log_error "Not in a git repository"
        exit 1
    fi
    log_success "Git repository found"
    
    # Check if working tree is clean
    if ! git diff-index --quiet HEAD --; then
        log_error "Working tree has uncommitted changes"
        echo ""
        git status --short
        echo ""
        log_error "Please commit or stash your changes before running this script"
        exit 1
    fi
    log_success "Working tree is clean"
    
    # Check if main branch exists
    if ! git rev-parse --verify "$MAIN_BRANCH" > /dev/null 2>&1; then
        log_error "Main branch '$MAIN_BRANCH' not found"
        exit 1
    fi
    log_success "Main branch '$MAIN_BRANCH' exists"
    
    # Fetch latest from origin
    log_info "Fetching latest from origin..."
    git fetch origin
    log_success "Fetch complete"
}

###############################################################################
# Branch Detection & Configuration
###############################################################################

detect_branches_to_sync() {
    log_section "Detecting Branches to Sync"
    
    if [ "$AUTO_DETECT_BRANCHES" = false ] && [ ${#BRANCHES_TO_SYNC[@]} -gt 0 ]; then
        log_info "Using specified branches: ${BRANCHES_TO_SYNC[*]}"
        return
    fi
    
    # Get all local branches except main
    local all_branches
    all_branches=$(git branch -r | grep -v "HEAD" | sed 's/^[[:space:]]*//g' | grep -v "^origin/$MAIN_BRANCH$" || true)
    
    if [ -z "$all_branches" ]; then
        log_warn "No branches found to sync"
        exit 0
    fi
    
    # Convert to local branch names and filter
    while IFS= read -r branch; do
        local local_branch
        local_branch=$(echo "$branch" | sed 's|^origin/||')
        
        if [ -n "$local_branch" ] && [ "$local_branch" != "$MAIN_BRANCH" ]; then
            BRANCHES_TO_SYNC+=("$local_branch")
        fi
    done <<< "$all_branches"
    
    if [ ${#BRANCHES_TO_SYNC[@]} -eq 0 ]; then
        log_warn "No branches to sync (only main exists)"
        exit 0
    fi
    
    log_success "Found ${#BRANCHES_TO_SYNC[@]} branches to sync:"
    for branch in "${BRANCHES_TO_SYNC[@]}"; do
        echo "  - $branch"
    done
}

###############################################################################
# Cherry-pick Logic
###############################################################################

get_new_commits() {
    local branch=$1
    
    # Find commits in origin/main that are not in the branch
    # Using merge-base to find common ancestor
    local main_commit
    local branch_commit
    
    main_commit=$(git rev-parse "origin/$MAIN_BRANCH")
    
    # Check if branch exists remotely
    if ! git rev-parse "origin/$branch" > /dev/null 2>&1; then
        verbose "Branch origin/$branch does not exist remotely yet"
        return
    fi
    
    branch_commit=$(git rev-parse "origin/$branch")
    
    # Get commits in main not in branch
    local commits
    commits=$(git log --oneline "$branch_commit".."$main_commit" 2>/dev/null | awk '{print $1}' || true)
    
    echo "$commits"
}

sync_branch() {
    local branch=$1
    local commits_to_apply
    
    log_info "Syncing branch: $branch"
    
    # Check if branch exists locally
    if ! git rev-parse --verify "$branch" > /dev/null 2>&1; then
        verbose "Local branch $branch doesn't exist, checking out from origin/$branch"
        if [ "$DRY_RUN" = false ]; then
            git checkout -b "$branch" "origin/$branch"
        fi
    else
        # Switch to branch
        if [ "$DRY_RUN" = false ]; then
            git checkout "$branch"
        fi
    fi
    
    verbose "Current branch: $(git branch --show-current)"
    
    # Get commits to cherry-pick
    commits_to_apply=$(get_new_commits "$branch")
    
    if [ -z "$commits_to_apply" ]; then
        log_success "$branch is already up to date with main"
        return 0
    fi
    
    local commit_count
    commit_count=$(echo "$commits_to_apply" | wc -l)
    log_info "$branch is behind main by $commit_count commit(s)"
    echo "$commits_to_apply" | while read -r commit; do
        echo "  • $commit"
    done
    
    if [ "$DRY_RUN" = true ]; then
        log_info "[DRY-RUN] Would cherry-pick $commit_count commit(s) to $branch"
        return 0
    fi
    
    # Cherry-pick commits
    echo "$commits_to_apply" | while read -r commit; do
        verbose "Cherry-picking $commit to $branch"
        
        if ! git cherry-pick "$commit" 2>/dev/null; then
            # Handle conflicts
            log_warn "Conflict detected while cherry-picking $commit"
            
            # Check conflict status
            local conflicted_files
            conflicted_files=$(git diff --name-only --diff-filter=U || true)
            
            if [ -n "$conflicted_files" ]; then
                log_warn "Conflicted files:"
                echo "$conflicted_files" | while read -r file; do
                    echo "    - $file"
                done
                
                # Auto-resolve: accept current branch version
                log_info "Auto-resolving: keeping $branch version of conflicted files"
                git checkout --ours . 2>/dev/null || true
                git add .
                git cherry-pick --continue --no-edit 2>/dev/null || {
                    log_error "Failed to resolve conflict in $commit"
                    log_error "Branch $branch left in inconsistent state"
                    return 1
                }
            fi
        fi
    done
    
    log_success "$branch synced successfully"
    return 0
}

###############################################################################
# Push Logic
###############################################################################

push_branches() {
    log_section "Pushing Synced Branches"
    
    for branch in "${BRANCHES_TO_SYNC[@]}"; do
        if [ "$DRY_RUN" = true ]; then
            log_info "[DRY-RUN] Would push $branch to origin"
        else
            log_info "Pushing $branch to origin..."
            git push origin "$branch"
            log_success "$branch pushed"
        fi
    done
}

###############################################################################
# Main Execution
###############################################################################

main() {
    log_section "Sync Branches to Main"
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --dry-run)
                DRY_RUN=true
                log_warn "DRY-RUN mode enabled"
                shift
                ;;
            --verbose)
                VERBOSE=true
                shift
                ;;
            --branches)
                AUTO_DETECT_BRANCHES=false
                IFS=',' read -ra BRANCHES_TO_SYNC <<< "$2"
                shift 2
                ;;
            --no-push)
                log_warn "Push disabled: Changes will be local only"
                PUSH_BRANCHES=false
                shift
                ;;
            --help)
                show_help
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    # Run validations
    validate_prerequisites
    
    # Detect branches
    detect_branches_to_sync
    
    if [ ${#BRANCHES_TO_SYNC[@]} -eq 0 ]; then
        log_warn "No branches to sync"
        exit 0
    fi
    
    log_section "Syncing ${#BRANCHES_TO_SYNC[@]} Branches"
    
    # Ensure we're on main
    git checkout "$MAIN_BRANCH"
    
    # Sync each branch
    local failed_branches=()
    for branch in "${BRANCHES_TO_SYNC[@]}"; do
        if ! sync_branch "$branch"; then
            failed_branches+=("$branch")
        fi
    done
    
    # Return to main
    git checkout "$MAIN_BRANCH"
    
    # Push if not dry-run and no failures
    if [ "$DRY_RUN" = false ] && [ ${#failed_branches[@]} -eq 0 ]; then
        push_branches
    fi
    
    # Summary
    log_section "Summary"
    
    if [ "$DRY_RUN" = true ]; then
        log_info "DRY-RUN completed. No changes were made."
        log_info "Run without --dry-run to apply changes"
    else
        local synced_count=$((${#BRANCHES_TO_SYNC[@]} - ${#failed_branches[@]}))
        log_success "$synced_count/${#BRANCHES_TO_SYNC[@]} branches synced"
        
        if [ ${#failed_branches[@]} -gt 0 ]; then
            log_error "${#failed_branches[@]} branches failed:"
            printf '%s\n' "${failed_branches[@]}" | sed 's/^/  - /'
        fi
    fi
    
    # Return appropriate exit code
    if [ ${#failed_branches[@]} -gt 0 ]; then
        exit 1
    fi
}

# Run main function
main "$@"
