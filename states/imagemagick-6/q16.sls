{% set policy_width = salt['pillar.get']('imagemagick-6:policy_width', '') %}
{% set policy_height = salt['pillar.get']('imagemagick-6:policy_height', '') %}

imagemagick-6.q16:
  pkg.latest

{% if policy_width %}
imagemagick-6-policy-width:
  file.line:
    - name: /etc/ImageMagick-6/policy.xml
    - match: <policy domain="resource" name="width" value=
    - content: <policy domain="resource" name="width" value="{{ policy_width }}"/>
    - mode: replace
    - indent: True
    - require:
      - pkg: imagemagick-6.q16
{% endif %}

{% if policy_height %}
imagemagick-6-policy-height:
  file.line:
    - name: /etc/ImageMagick-6/policy.xml
    - match: <policy domain="resource" name="height" value=
    - content: <policy domain="resource" name="height" value="{{ policy_height }}"/>
    - mode: replace
    - indent: True
    - require:
      - pkg: imagemagick-6.q16
{% endif %}
