# Automatically load environment variables if a .env file exists

set dotenv-load

# Staging and Production Reference IDs

PROD_REF := "csrxphbmkdklpvouwurr"

# Running `just` without arguments will list all available commands

default:
    @just --list

# ==============================================================================

# LOCAL DEVELOPMENT COMMANDS

# ==============================================================================

# Start local Supabase Docker containers

start:
    supabase start

# Stop local Supabase Docker containers

stop:
    supabase stop

# Check connection status, ports, and API keys

status:
    supabase status

# Reset local database (applies all migrations + seed.sql)

reset:
    supabase db reset

# Auto-generate a migration file from changes made via local Studio GUI

# Usage: just diff add_posts_table

diff name:
    supabase db diff -f {{ name }}

# Create an empty SQL migration file to write manual raw SQL

# Usage: just migration create_triggers

migration name:
    supabase migration new {{ name }}

# ==============================================================================

# REMOTE & DEPLOYMENT COMMANDS

# ==============================================================================

# Link local project to the Production cloud environment

link-prod:
    supabase link --project-ref {{ PROD_REF }}

# Push all unapplied local migrations to whichever remote DB is currently linked

push:
    supabase db push
