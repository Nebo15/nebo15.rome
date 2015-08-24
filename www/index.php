<?php
error_reporting('E_ALL');
ini_set('display_errors', 'On');
$postdata = file_get_contents("php://input");
if (is_string($postdata)) {
    file_put_contents(dirname(__FILE__) . '/logs/main.log', $postdata . PHP_EOL, FILE_APPEND);
    $data = json_decode($postdata);
    $project = $data->project;
    $branch = $data->branch;
    $file = '/www/' . $project . '/bin/update.sh';
    if (file_exists($file)) {
        exec('sudo /bin/bash ' . $file . ' > /tmp/debug_info', $a);
        if ($project == 'mbank.web.mobile') {
            exec('sudo /bin/chown www-data.www-data -Rf /www/mbank.web.mobile/dist');
            exec('sudo /bin/chown www-data.www-data -Rf /www/mbank.web.mobile/.tmp');
        }
    }
}