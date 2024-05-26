---
layout: page
title: 메인
id: home
permalink: /
---

# 2️⃣ 기호 2번 공약 안내

<p style="padding: 3em 1em; background: #f5f7ff; border-radius: 4px;">
  Take a look at <span style="font-weight: bold">[[Your first note]]</span> to get started on your exploration.
</p>

This digital garden template is free, open-source, and [available on GitHub here](https://github.com/maximevaillancourt/digital-garden-jekyll-template).

The easiest way to get started is to read this [step-by-step guide explaining how to set this up from scratch](https://maximevaillancourt.com/blog/setting-up-your-own-digital-garden-with-jekyll).

<h3>공약 소개</h3>

<ul>
  {% for post in site.info %}
    <li>
      [[{{post.url}}]]
    </li>
  {% endfor %}
</ul>

<h3>선거 블로그</h3>

<ul>
  {% for post in site.blog %}
    <li>
      [[{{post.url}}]]
    </li>
  {% endfor %}
</ul>


<style>
  .wrapper {
    max-width: 46em;
  }
</style>
