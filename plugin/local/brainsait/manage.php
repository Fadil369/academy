<?php
require(__DIR__ . '/../../config.php');

require_login();

$context = context_system::instance();
require_capability('local/brainsait:manage', $context);

$PAGE->set_url(new moodle_url('/local/brainsait/manage.php'));
$PAGE->set_context($context);
$PAGE->set_title(get_string('pluginname', 'local_brainsait'));
$PAGE->set_heading(get_string('pluginname', 'local_brainsait'));

echo $OUTPUT->header();

echo html_writer::tag('h2', get_string('manage', 'local_brainsait'));

// Provide a form/button to trigger generation.
$triggerurl = new moodle_url('/local/brainsait/run.php', []);
echo html_writer::div(html_writer::link($triggerurl, get_string('rungeneration', 'local_brainsait'), ['class' => 'btn btn-primary']));

// List generated artifacts if available.
$presentation = $CFG->dataroot . '/brainsait/export/course_export/interactive-presentation.html';
$backup = $CFG->dataroot . '/brainsait/export/course_export/brainsait_ai_course_backup.mbz';

echo html_writer::start_tag('ul');
if (file_exists($presentation)) {
    $base = get_config('local_brainsait', 'presentationbaseurl');
    if (!empty($base)) {
        $publicurl = new moodle_url(rtrim($base, '/') . '/interactive-presentation.html');
        echo html_writer::tag('li', html_writer::link($publicurl, get_string('view_presentation', 'local_brainsait')));
    }
}
if (file_exists($backup)) {
    $download = new moodle_url('/local/brainsait/download.php');
    echo html_writer::tag('li', html_writer::link($download, get_string('download_backup', 'local_brainsait')));
}
echo html_writer::end_tag('ul');

echo $OUTPUT->footer();
