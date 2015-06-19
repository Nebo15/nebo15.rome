<?php
error_reporting('E_ALL');
ini_set('display_errors', 'On');
exec('/bin/bash /www/nebo15.rome/bin/update.sh', $a);
print_r($a);