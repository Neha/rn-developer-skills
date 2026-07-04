param(
  [ValidateSet("all", "codex", "claude")]
  [string]$Mode = "all",
  [string]$CodexDir = $(if ($env:CODEX_SKILLS_DIR) { $env:CODEX_SKILLS_DIR } else { Join-Path $HOME ".agents/skills" }),
  [string]$ClaudeDir = $(if ($env:CLAUDE_SKILLS_DIR) { $env:CLAUDE_SKILLS_DIR } else { Join-Path $HOME ".claude/skills" }),
  [switch]$Force,
  [switch]$DryRun
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RootDir = Resolve-Path (Join-Path $ScriptDir "..")
$SkillsDir = Join-Path $RootDir "skills"
$DistDir = Join-Path $RootDir "dist/claude"

function Invoke-Step {
  param(
    [string]$Message,
    [scriptblock]$Action
  )

  if ($DryRun) {
    Write-Host "[dry-run] $Message"
  } else {
    & $Action
  }
}

function Install-SkillDirs {
  param(
    [string]$TargetRoot,
    [string]$Label
  )

  Write-Host "Installing $Label skills to $TargetRoot"
  Invoke-Step "New-Item -ItemType Directory -Force $TargetRoot" {
    New-Item -ItemType Directory -Force -Path $TargetRoot | Out-Null
  }

  $count = 0
  foreach ($skill in Get-ChildItem -Path $SkillsDir -Directory) {
    if (-not (Test-Path (Join-Path $skill.FullName "SKILL.md"))) {
      continue
    }

    $target = Join-Path $TargetRoot $skill.Name
    if (Test-Path $target) {
      if ($Force) {
        Invoke-Step "Remove-Item -Recurse -Force $target" {
          Remove-Item -Recurse -Force -Path $target
        }
      } else {
        Write-Host "Skipping existing $Label skill: $($skill.Name) (use -Force to replace)"
        continue
      }
    }

    Invoke-Step "Copy-Item -Recurse $($skill.FullName) $TargetRoot" {
      Copy-Item -Recurse -Path $skill.FullName -Destination $TargetRoot
    }
    $count += 1
  }

  Write-Host "Installed $count $Label skill(s)."
}

function Compress-ClaudeZips {
  Write-Host "Packaging Claude ZIP files in $DistDir"
  Invoke-Step "New-Item -ItemType Directory -Force $DistDir" {
    New-Item -ItemType Directory -Force -Path $DistDir | Out-Null
  }

  $count = 0
  foreach ($skill in Get-ChildItem -Path $SkillsDir -Directory) {
    if (-not (Test-Path (Join-Path $skill.FullName "SKILL.md"))) {
      continue
    }

    $zipPath = Join-Path $DistDir "$($skill.Name).zip"
    if ((Test-Path $zipPath) -and -not $Force) {
      Write-Host "Skipping existing Claude ZIP: $zipPath (use -Force to replace)"
      continue
    }

    Invoke-Step "Compress-Archive $($skill.FullName) $zipPath" {
      if (Test-Path $zipPath) {
        Remove-Item -Force -Path $zipPath
      }
      Compress-Archive -Path $skill.FullName -DestinationPath $zipPath
    }
    $count += 1
  }

  Write-Host "Packaged $count Claude ZIP file(s)."
}

if (-not (Test-Path $SkillsDir)) {
  throw "Skills directory not found: $SkillsDir"
}

switch ($Mode) {
  "all" {
    Install-SkillDirs -TargetRoot $CodexDir -Label "Codex"
    Install-SkillDirs -TargetRoot $ClaudeDir -Label "Claude"
    Compress-ClaudeZips
  }
  "codex" {
    Install-SkillDirs -TargetRoot $CodexDir -Label "Codex"
  }
  "claude" {
    Install-SkillDirs -TargetRoot $ClaudeDir -Label "Claude"
    Compress-ClaudeZips
  }
}

Write-Host "Done. Restart Codex or Claude Code if the skills do not appear immediately."
