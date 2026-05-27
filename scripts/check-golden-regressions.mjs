#!/usr/bin/env node

/**
 * check-golden-regressions.mjs
 *
 * Runs golden tests WITHOUT --update-goldens to detect visual regressions.
 * Outputs a human-readable summary + machine-readable JSON report.
 *
 * Exit 0 = no regressions, exit 1 = regressions found.
 */

import { execSync } from 'node:child_process';
import { writeFileSync, mkdirSync } from 'node:fs';
import { dirname } from 'node:path';

const GOLDEN_TEST_DIR = 'test/goldens/components/';
const REPORT_PATH = 'kb/sync-logs/golden-regressions.json';

// Use plain `flutter` in CI (subosito/flutter-action), `fvm flutter` locally
const FLUTTER = process.env.CI ? 'flutter' : 'fvm flutter';

function run() {
  let stdout = '';
  let exitCode = 0;

  try {
    stdout = execSync(`${FLUTTER} test ${GOLDEN_TEST_DIR}`, {
      encoding: 'utf-8',
      stdio: ['pipe', 'pipe', 'pipe'],
      timeout: 5 * 60 * 1000, // 5 min
    });
  } catch (err) {
    // flutter test exits non-zero when tests fail
    stdout = (err.stdout || '') + '\n' + (err.stderr || '');
    exitCode = err.status ?? 1;
  }

  // Parse golden mismatch lines
  // Typical patterns:
  //   "Golden file test/goldens/components/badge_small.png did not match"
  //   "══╡ EXCEPTION CAUGHT BY FLUTTER TEST FRAMEWORK ╞══ ... goldenFileComparator"
  //   "Expected: ... golden file ... badge_small.png"
  const mismatchPattern = /golden\s+(?:file\s+)?(?:test\/goldens\/components\/)?(\S+\.png)/gi;
  const mismatches = new Set();

  for (const match of stdout.matchAll(mismatchPattern)) {
    // Extract just the filename (strip any path prefix)
    const filename = match[1].split('/').pop();
    mismatches.add(filename);
  }

  // Also catch lines like "  ● <test name> ... image mismatch"
  const testFailPattern = /(?:FAIL|✗|●)\s+.*?(\w[\w-]*\.png)/gi;
  for (const match of stdout.matchAll(testFailPattern)) {
    mismatches.add(match[1]);
  }

  const regressions = [...mismatches].sort();
  const hasRegressions = regressions.length > 0 || exitCode !== 0;

  // Build report
  const report = {
    timestamp: new Date().toISOString(),
    hasRegressions,
    count: regressions.length,
    files: regressions,
    exitCode,
    // If tests failed but we couldn't parse specific files, flag it
    unparsedFailure: exitCode !== 0 && regressions.length === 0,
  };

  // Write JSON report
  mkdirSync(dirname(REPORT_PATH), { recursive: true });
  writeFileSync(REPORT_PATH, JSON.stringify(report, null, 2) + '\n');

  // Human-readable output
  if (hasRegressions) {
    if (regressions.length > 0) {
      console.log(`\n🔴 ${regressions.length} golden regression(s): ${regressions.join(', ')}`);
    } else {
      console.log('\n🔴 Golden tests failed (could not parse specific files from output)');
    }
    console.log(`\nFull report: ${REPORT_PATH}`);
    process.exit(1);
  } else {
    console.log('\n✅ No golden regressions detected.');
    process.exit(0);
  }
}

run();
