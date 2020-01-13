{% include 'vendors.swig' %}

{{- next_js('utils.js') }}
{%- if theme.motion.enable %}
  {{- next_js('motion.js') }}
{%- endif %}

{%- set scheme_script = 'schemes/' + theme.scheme | lower + '.swig' %}
{% include scheme_script %}

{{- next_js('next-boot.js') }}
{%- if theme.bookmark.enable %}
  {{- next_js('bookmark.js') }}
{%- endif %}
{%- if theme.pjax %}
  {% include 'pjax.swig' %}
{%- endif %}
{% include 'three.swig' %}

{%- if theme.love.enable %}
  {{- next_js('love.js') }}
{%- endif %}

{%- if theme.particle.enable %}
  {{- next_js('love.js') }}
{%- endif %}
{%- if theme.clipboard.enable %}
  {{- next_js('clipboard.min.js') }}
  {{- next_js('clipboard-use.js') }}
{%- endif %}
