---
layout: default
title: 首页
---

# 欢迎来到小明的博客

这里是一个记录技术探索、生活趣事和奇思妙想的地方。

{% for post in site.posts %}
### [{{ post.title }}]({{ post.url | relative_url }})
*{{ post.date | date: "%Y-%m-%d" }}*
{% endfor %}
