<?php
error_reporting('E_ALL');
ini_set('display_errors', 'On');
$postdata = file_get_contents("php://input");
file_put_contents(dirname(__FILE__) . '/logs/main.log', $postdata);
