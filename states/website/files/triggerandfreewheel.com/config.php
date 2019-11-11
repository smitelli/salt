<?php

  class Config {
    // This is determined by the location of bootstrap.php
    public $base_dir = NULL;

    // Nothing here should *ever* have a trailing slash
    public $app_uri    = 'https://www.triggerandfreewheel.com';
    public $static_uri = 'https://www.triggerandfreewheel.com/static';

    // Database stuff
    // If $database_sock is a string (not FALSE), $database_host is ignored.
    public $database_host = '';
    public $database_sock = '/run/mysqld/mysqld.sock';
    public $database_user = 'triggerandfreewheel-com';
    public $database_pass = '';
    public $database_name = 'triggerandfreewheel';

    // Local timezone
    // This is important because it influences the definition of "midnight" when
    // deciding when to show new comics.
    public $timezone = 'America/New_York'

    // Some strings that appear in a lot of places
    public $site_title       = 'Trigger and Freewheel';
    public $site_subtitle    = "It's a webcomic.";
    public $site_description = 'A webcomic which pokes fun at technology, society, and the absurdities of modern life.';

    // The default URI parts to use when visiting the root directory
    public $default_request = array('comic');

    // List of "static"-ish pages to include in the sitemap
    public $page_list = array('/', '/about', '/archive', '/comic', '/links');

    // Values that begin with a slash are absolute paths and left unmodified.
    // Values that don't begin with a slash are relative to computed $base_dir.
    public $template_dir = 'templates';
    public $compile_dir  = '/var/opt/website/triggerandfreewheel.com/compile';
    public $upload_dir   = '/var/opt/website/triggerandfreewheel.com/uploads';

    // List of users who are allowed into the admin panel
{{ salt['pillar.get']('website:triggerandfreewheel-com:user_list') }}

    // Read/write credentials for a Twitter account
    public $consumer_key        = "{{ salt['pillar.get']('twitterapi:smitelli:consumer_key') }}";
    public $consumer_secret     = "{{ salt['pillar.get']('twitterapi:smitelli:consumer_secret') }}";
    public $access_token        = "{{ salt['pillar.get']('twitterapi:smitelli:access_token') }}";
    public $access_token_secret = "{{ salt['pillar.get']('twitterapi:smitelli:access_token_secret') }}";

    public function __construct($base_dir) {
      // Determine the app's real root during instantiation
      $this->base_dir = $base_dir;

      if ($this->template_dir[0] != '/') {
        $this->template_dir = $base_dir . '/' . $this->template_dir;
      }

      if ($this->compile_dir[0] != '/') {
        $this->compile_dir = $base_dir . '/' . $this->compile_dir;
      }

      if ($this->upload_dir[0] != '/') {
        $this->upload_dir   = $base_dir . '/' . $this->upload_dir;
      }

      date_default_timezone_set($this->timezone);
    }
  }

?>
