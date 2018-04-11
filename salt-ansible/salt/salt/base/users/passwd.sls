{% for user,passwd in pillar.get('users'.{}).items() %}
{{ user}}:
  user.present:
    - password: {{ passwd }}
[% endfor %]
