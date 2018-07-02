<?php

  // MySQL configuration stuff
  define('MYSQL_HOST', NULL);
  define('MYSQL_SOCK', '/run/mysqld/mysqld.sock');
  define('MYSQL_DB',   'sodasrv');
  define('MYSQL_USER', 'sodasrv');
  define('MYSQL_PASS', '');

  // Client pre-shared auth token
  define('LISTENER_AUTH', "{{ salt['pillar.get']('project:sodasrv:listener_auth_token') }}");

  // Misc
  define('COMPILE_DIR',    '/var/opt/project/sodasrv/compile');
  define('DEFAULT_PAGE',   'default');
  define('SHOW_LOG_LINES', 50);

  // Behavior parameters
  define('PROBE_LONG_IGNORE',   45);  //sec
  define('PROBE_SHORT_IGNORE', 1.5);  //sec
  define('TEMP_AVG_POINTS',      5);
  define('TEMP_HOT_POINT',      48);  //degF
  define('TEMP_COLD_POINT',     33);  //degF
  define('QUANTITY_AVG_POINTS',  5);
  define('QUANTITY_CANS_MAX',   12);  //cans
  define('QUANTITY_CANS_LOW',    4);  //cans

  // Internal constants
  define('ALARM_NONE',     'alarm_off');
  define('ALARM_TOO_HOT',  'alarm_hot');
  define('ALARM_TOO_COLD', 'alarm_cold');
  define('ALARM_CANS_LOW', 'alarm_cans_low');

  // This function converts seconds (from the serial probe) to degrees F
  function data_to_temperature($data) {
    /* Original conversion curve from Summer 2003
    $log_d = log($data) / log(10);
    return (20.39 * $log_d * $log_d) - (144.6 * $log_d) + 176.1;
    */

    return (0.3449 * $data * $data) - (12.15 * $data) + 138.9;
  }

  // This function converts seconds (from the serial probe) to quantity
  function data_to_quantity($data) {
    return (0.5271 * $data) - 1.011;
  }

?>
