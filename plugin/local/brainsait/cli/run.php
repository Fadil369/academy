<?php
// CLI runner for BrainsAIT generator
define('CLI_SCRIPT', true);

require(__DIR__ . '/../../../config.php');

// No login needed for CLI, but keep capability check comment for reference.
// $context = context_system::instance();
// require_capability('local/brainsait:manage', $context);

require_once(__DIR__ . '/../classes/generator.php');
echo "BrainsAIT Generator\n";

list($ok, $log) = \local_brainsait\generator::run();

if ($ok) {
    echo "SUCCESS\n";
} else {
    echo "FAILED\n";
}
echo $log . "\n";

exit($ok ? 0 : 1);
