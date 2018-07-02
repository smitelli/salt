# This state file reads the `timezone` key from the pillar, if present. The
# following sub-keys are available:
#   - name: The text name of the timezone to use, like `America/New_York`
#   - utc: If True, the hardware clock is set to UTC regardless of timezone

{% set tz = pillar.get('timezone', {}) %}

{{ tz.get('name', 'UTC') | yaml_encode }}:
  timezone.system:
    - utc: {{ tz.get('utc', True) | yaml_encode }}
