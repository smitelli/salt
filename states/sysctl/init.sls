# This state file reads the `sysctl` key from the pillar, if present. Each
# subkey found is added to the persistent managed sysctls.

{% for name, value in pillar.get('sysctl', {}).items() -%}
  {{ name | yaml_encode }}:
    sysctl.present:
      - value: {{ value | yaml_encode }}
{% endfor %}
