PREFERRED_URL_SCHEME = '{{ scheme }}'

SQLALCHEMY_DATABASE_URI = 'mysql:///windowbox-scottsmitelli?unix_socket=/run/mysqld/mysqld.sock&charset=utf8mb4'

ATTACHMENTS_PATH = '/var/opt/website/pics.scottsmitelli.com/attachments'
DERIVATIVES_PATH = '/var/opt/website/pics.scottsmitelli.com/derivatives'
USE_X_ACCEL_REDIRECT = True

GOOGLE_MAPS_API_KEY = "{{ salt['pillar.get']('googleapi:maps_windowbox:api_key') }}"

IMAP_FETCH_HOST = "{{ salt['pillar.get']('website:pics-scottsmitelli-com:imap_fetch_host') }}"
IMAP_FETCH_USER = "{{ salt['pillar.get']('website:pics-scottsmitelli-com:imap_fetch_user') }}"
IMAP_FETCH_PASSWORD = "{{ salt['pillar.get']('website:pics-scottsmitelli-com:imap_fetch_password') }}"
