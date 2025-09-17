<?php
namespace local_brainsait;

defined('MOODLE_INTERNAL') || die();

class generator {
    /**
     * Runs the Python-based course generator and packager.
     * - Prefers plugin-local bin/ scripts, falls back to /home/ubuntu/projects/academy
     * - Writes artifacts under $CFG->dataroot/brainsait/export
     *
     * @return array [bool success, string log]
     */
    public static function run(): array {
        global $CFG;

        $log = [];

        $dataroot = rtrim($CFG->dataroot, '/');
        $exportdir = $dataroot . '/brainsait/export';
        if (!is_dir($exportdir)) {
            @mkdir($exportdir, 0777, true);
        }
        if (!is_writable($exportdir)) {
            $log[] = "Export directory not writable: {$exportdir}";
            return [false, implode("\n", $log)];
        }

        $plugindir = dirname(__DIR__);
        $bin = $plugindir . '/bin';
        $gen = $bin . '/advanced-course-generator.py';
        $pack = $bin . '/moodle-packager.py';

        // Fallbacks for server layout used earlier.
        if (!file_exists($gen)) {
            $gen = '/home/ubuntu/projects/academy/advanced-course-generator.py';
        }
        if (!file_exists($pack)) {
            $pack = '/home/ubuntu/projects/academy/moodle-packager.py';
        }

        if (!file_exists($gen) || !file_exists($pack)) {
            $log[] = 'Python generator or packager not found. Ensure scripts exist in plugin/bin or server path.';
            $log[] = "Checked: {$gen}";
            $log[] = "Checked: {$pack}";
            return [false, implode("\n", $log)];
        }

        $python = 'python3';

        // Run generator in dataroot export dir.
        $cmd1 = "cd " . escapeshellarg($exportdir) . " && " . escapeshellcmd($python) . " " . escapeshellarg($gen);
        $log[] = "+ $cmd1";
        $out1 = [];
        $ret1 = 0;
        @exec($cmd1 . ' 2>&1', $out1, $ret1);
        $log = array_merge($log, $out1);
        if ($ret1 !== 0) {
            $log[] = "Generator failed with code {$ret1}";
            return [false, implode("\n", $log)];
        }

        // Run packager in same directory.
        $cmd2 = "cd " . escapeshellarg($exportdir) . " && " . escapeshellcmd($python) . " " . escapeshellarg($pack);
        $log[] = "+ $cmd2";
        $out2 = [];
        $ret2 = 0;
        @exec($cmd2 . ' 2>&1', $out2, $ret2);
        $log = array_merge($log, $out2);
        if ($ret2 !== 0) {
            $log[] = "Packager failed with code {$ret2}";
            return [false, implode("\n", $log)];
        }

        // Optional: copy presentation to public dir if configured.
    $publicdir = \get_config('local_brainsait', 'publicdir');
        $presentation = $exportdir . '/course_export/interactive-presentation.html';
        if (!empty($publicdir) && file_exists($presentation)) {
            if (!is_dir($publicdir)) {
                @mkdir($publicdir, 0775, true);
            }
            $dest = rtrim($publicdir, '/') . '/interactive-presentation.html';
            if (@copy($presentation, $dest)) {
                $log[] = "Copied presentation to public dir: {$dest}";
            } else {
                $log[] = "Warning: failed to copy presentation to public dir: {$publicdir}";
            }
        }

        return [true, implode("\n", $log)];
    }
}
