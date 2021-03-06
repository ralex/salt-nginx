{% set openresty = salt['pillar.get']('nginx:openresty', false) %}

{% if openresty %}
deb http://openresty.org/package/debian {{ salt['pillar.get'](lsb_distrib_codename) }} openresty:
  pkgrepo.managed:
    - file: /etc/apt/sources.list.d/openresty.list
    - key_url: https://openresty.org/package/pubkey.gpg

nginx.service:
  service.dead:
    - enable: false

nginx:
  pkg.removed:

openresty:
  pkg.installed:
{% else %}
{% if salt['pillar.get']('nginx:mainline', false ) %}
{% set mainline = 'mainline/' %}
{% else %}
{% set mainline = '' %}
{% endif %}
deb https://nginx.org/packages/{{ mainline }}debian/ {{ salt['pillar.get'](lsb_distrib_codename) }} nginx:
  pkgrepo.managed:
    - file: /etc/apt/sources.list.d/nginx.list
    - key_url: https://nginx.org/keys/nginx_signing.key

openresty.service:
  service.dead:
    - enable: false

openresty:
  pkg.removed:

nginx:
  pkg.installed:

nginx.service:
  service.running:
    - enable: true
{% endif %}

{% for vhost in salt['pillar.get']('nginx:vhosts') %}
/etc/nginx/conf.d/{{ vhost }}.conf:
  file.managed:
      - source: salt://nginx/vhost.conf.j2
      - template: jinja
      - user: root
      - group: root
      - mode: '0644'
{% endfor %}
