---
layout: page
title: 메인
id: home
permalink: /
---

<img src="assets/uploaded/giho2.png" alt="후보 소개 현수막" width="100%">

기호 2번, <strong>심재민 정태훈 김주영</strong> 후보의 공약 소개 및 선거 블로그입니다. 다양한 공약이 매일 업데이트되고, 홍보 자료도 올라오니까 꼭 참고해 주세요!

<p style="padding: 1em 1em; background: #f5d8bc; border-radius: 4px;">
  공약을 제안하고 싶으시다고요? <span style="font-weight: bold"><a href="https://bit.ly/number2-we-listen">여기에서</a></span> 직접 말씀해 주세요! <span style="font-weight: bold"><a href="https://open.kakao.com/o/sMnhF0tg">카카오톡 오픈채팅방</a></span>도 운영하고 있습니다!
</p>

<h3>공약 소개</h3>

<ul>
  {% for post in site.info %}
    <li>
      <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
    </li>
  {% endfor %}
</ul>

<h3>선거 블로그</h3>

<ul>
  {% for post in site.blog reversed %}
    <li>
      <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
    </li>
  {% endfor %}
</ul>


<style>
  .wrapper {
    max-width: 46em;
  }
</style>
