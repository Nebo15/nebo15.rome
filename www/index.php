<?php
error_reporting('E_ALL');
ini_set('display_errors', 'On');
$postdata = file_get_contents("php://input");
if (is_string($postdata)) {
    file_put_contents(dirname(__FILE__) . '/logs/main.log', $postdata . PHP_EOL, FILE_APPEND);
    $data = json_decode($postdata);
    $project = $data->project;
    $branch = $data->branch;
    if ($project == 'mbank.web.mobile') {
        exec('/bin/bash /www/mbank.web.mobile/bin/autodeploy-git.sh > /tmp/debug_info', $a);
        exec('sudo /bin/bash /www/mbank.web.mobile/bin/autodeploy-build.sh >> /tmp/debug_info', $a);
        exec('sudo /bin/chown www-data.www-data -Rf /www/mbank.web.mobile/dist');
        exec('sudo /bin/chown www-data.www-data -Rf /www/mbank.web.mobile/.tmp');
    }
}