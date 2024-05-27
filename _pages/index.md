---
layout: page
title: 메인
id: home
permalink: /
---

# 2️⃣ 기호 2번 공약 안내

<p style="padding: 3em 1em; background: #f5f7ff; border-radius: 4px;">
  공약을 제안하고 싶으시다고요? [여기에서](example.com) 직접 말씀해 주세요!
</p>

기호 2번, <strong>심재민 정태훈 김주영</strong> 후보의 공약 소개 및 선거 블로그입니다. 다양한 공약이 매일 업데이트되고, 홍보 자료도 올라오니까 꼭 참고해 주세요!

<h3>공약 소개</h3>

<ul>
  {% for post in site.info %}
    <li>
      <a href="{{ post.url }}">{{ post.title }}</a>
    </li>
  {% endfor %}
</ul>

<h3>선거 블로그</h3>

<ul>
  {% for post in site.blog | sort: 'last_updated' %}
    <li>
      <a href="{{ post.url }}">{{ post.title }}</a>
    </li>
  {% endfor %}
</ul>


<style>
  .wrapper {
    max-width: 46em;
  }
</style>
