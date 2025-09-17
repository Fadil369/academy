<?php
defined('MOODLE_INTERNAL') || die();

if ($hassiteconfig) {
    $ADMIN->add('localplugins', new admin_externalpage(
        'local_brainsait_manage',
        get_string('pluginname', 'local_brainsait'),
        new moodle_url('/local/brainsait/manage.php'),
        'local/brainsait:manage'
    ));

    $settings = new admin_settingpage('local_brainsait', get_string('settings', 'local_brainsait'));
    $settings->add(new admin_setting_configtext(
        'local_brainsait/presentationbaseurl',
        get_string('presentationurl', 'local_brainsait'),
        'Public base URL where interactive presentations are served (e.g., https://lms.brainsait.com/brainsait-demo/)',
        '',
        PARAM_URL
    ));
    $settings->add(new admin_setting_configtext(
        'local_brainsait/publicdir',
        'Public presentation directory',
        'Absolute directory path on the web server where the plugin can copy presentation files (ensure www-data can write). Example: /var/www/brainsait-web',
        '',
        PARAM_RAW_TRIMMED
    ));
    $ADMIN->add('localplugins', $settings);
}
