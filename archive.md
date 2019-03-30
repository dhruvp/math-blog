---
layout: page
title: Archive
---

## Blog Posts

{% for post in site.posts %}
  * {{ post.date | date_to_string }} &raquo; [ {{ post.title }} ]({{ post.url }})
{% endfor %}
* 21 Apr 2017 &raquo; [A Brief History of CNNs in Image Segmentation: From R-CNN to Mask R-CNN](https://blog.athelas.com/a-brief-history-of-cnns-in-image-segmentation-from-r-cnn-to-mask-r-cnn-34ea83205de4)
* 10 Mar 2017 &raquo; [Baidu's Deep Voice Explained: Part 2 - Training](https://blog.athelas.com/paper-1-baidus-deep-voice-675a323705df)
* 6 Mar 2017 &raquo; [Baudu's Deep Voice Explained: Part 1 - The Inference Pipeline](https://blog.athelas.com/paper-1-baidus-deep-voice-675a323705df)
