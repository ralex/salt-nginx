deb http://openresty.org/package/debian {{ salt['pillar.get'](lsb_distrib_codename') }} openresty:
  pkgrepo.managed:
    - file: /etc/apt/sources.list.d/openresty.list
    - key_url: https://openresty.org/package/pubkey.gpg

{% for vhost in salt['pillar.get']('nginx:vhosts')%}
/etc/nginx/conf.d/{{ vhost }}.conf:
  file.managed:
      - source: salt://nginx/vhost.conf.j2
      - template: jinja
      - user: root
      - group: root
      - mode: 644
{% endfor %}
