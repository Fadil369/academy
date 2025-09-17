<?php
defined('MOODLE_INTERNAL') || die();

// Guards for static analysis outside Moodle.
if (!defined('RISK_CONFIG')) {
    define('RISK_CONFIG', 0x10);
}
if (!defined('CONTEXT_SYSTEM')) {
    define('CONTEXT_SYSTEM', 10);
}
if (!defined('CAP_ALLOW')) {
    define('CAP_ALLOW', 1);
}

$capabilities = [
    'local/brainsait:manage' => [
        'riskbitmask' => RISK_CONFIG,
        'captype' => 'write',
        'contextlevel' => CONTEXT_SYSTEM,
        'archetypes' => [
            'manager' => CAP_ALLOW,
        ],
    ],
];
