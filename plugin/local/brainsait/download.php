<?php
require(__DIR__ . '/../../config.php');
require_login();

$context = context_system::instance();
require_capability('local/brainsait:manage', $context);

require_once($CFG->libdir . '/filelib.php');

$backup = $CFG->dataroot . '/brainsait/export/course_export/brainsait_ai_course_backup.mbz';
if (!file_exists($backup)) {
    print_error('filenotfound');
}

send_file($backup, 'brainsait_ai_course_backup.mbz', 0, 0, true, true);
