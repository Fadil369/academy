<?php
require(__DIR__ . '/../../config.php');

require_login();
$context = context_system::instance();
require_capability('local/brainsait:manage', $context);

use local_brainsait\generator;

$PAGE->set_url(new moodle_url('/local/brainsait/run.php'));
$PAGE->set_context($context);
$PAGE->set_title(get_string('pluginname', 'local_brainsait'));
$PAGE->set_heading(get_string('pluginname', 'local_brainsait'));

echo $OUTPUT->header();

list($ok, $log) = generator::run();

if ($ok) {
    echo $OUTPUT->notification(get_string('generation_completed', 'local_brainsait'), 'notifysuccess');
} else {
    echo $OUTPUT->notification(get_string('generation_log', 'local_brainsait'), 'notifyproblem');
}

echo html_writer::tag('pre', s($log));

$back = new moodle_url('/local/brainsait/manage.php');
echo html_writer::div(html_writer::link($back, get_string('manage', 'local_brainsait'), ['class' => 'btn btn-secondary']));

echo $OUTPUT->footer();
