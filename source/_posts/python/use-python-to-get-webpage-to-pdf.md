---
title: 使用python获取网页内容并转换pdf
date: 2020-05-31 07:55:53
categories:
- python
tags:
- beautiful soup
- reportlab
- python
---

# 目的

最近看到有一本书以网页的形式放到了一个网站上, 想把它扒下来并转换成pdf, 想了想python好像特别适合做这种事情, 试了一下还真的可以。用到了两个第三方模块: beautiful soup 和 reportlab。

# 过程

首先我看了一下结构, 章节目录是一个网页, 每个章节都是一个链接, 点进去是对应的章节内容, 那么首要任务就是将目录扒下来。

## 目录

首先打开f12, 看到了这个网页的结构, 每一个章节都是一个 `<span>` 标签, 并且有对应的 class 名称:

<!--more-->

![f12](/images/python/use-python-to-get-webpage-to-pdf/pythonHtmlToPdf1.png)

可以看到章名称的class是chapterToc, 小节名称的class是likesectionToc, 搞明白页面结构之后就可以开始动笔了。

先写一个方法, 用来获取链接中的内容的soup对象:

```py
import re
from bs4 import BeautifulSoup, NavigableString, Tag, Comment
import urllib.request

# 获取全部的html
def getAllHtml(url):
  response1 = urllib.request.urlopen(url)
  html_doc = response1.read()
  #创建一个BeautifulSoup解析对象
  soup = BeautifulSoup(html_doc, "html5lib", from_encoding="iso-8859-1")
  for element in soup(text=lambda text: isinstance(text, Comment)):
    element.extract()
  for s in soup(['hr']):
    s.extract()

  return soup
```

接下来是获取我们需要的内容了:

```py
soup = getAllHtml('http://bob.cs.sonoma.edu/IntroCompOrg-x64/book.html')
allChapter = soup.find_all('span', class_='chapterToc')
allAppendixToc = soup.find_all('span', class_='appendixToc')
allSectionToc = soup.find_all('span', class_='sectionToc')
```

这里我们将章节和小节标题都获取到了, 接着是将这些内容保存至pdf文件中, 使用的是 reportlab, 在文件开头处加入需要引入的工具:

```py
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, PageBreak, Image, Table, TableStyle
from reportlab.lib.colors import white, black, blue
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.rl_config import defaultPageSize
from reportlab.lib.units import inch
from reportlab.lib.enums import TA_RIGHT, TA_CENTER, TA_LEFT
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
```

接着上一段代码创建pdf:

```py
# 注册需要使用的字体
pdfmetrics.registerFont(TTFont('new-roman', 'C:\\Windows\\Fonts\\times.ttf'))
pdfmetrics.registerFont(TTFont('cambria', 'C:\\Windows\\Fonts\\cambria.ttc'))

# 自定义样式
chapterStyle = ParagraphStyle(name='Normal',
                              fontName='new-roman',
                              textColor=blue,
                              fontSize=13,
                              alignment=TA_LEFT,
                              leading=13,
                              spaceAfter=8)

sectionStyle = ParagraphStyle(name='Normal',
                              fontName='new-roman',
                              textColor=blue,
                              firstLineIndent=32,
                              fontSize=10,
                              spaceAfter=3)

fileName = "IntroCompOrg.pdf"

# 创建pdf文档对象
doc = SimpleDocTemplate(fileName)
Story = [Spacer(3, 2 * inch)]

# 将刚刚获取到的内容放入pdf对象中
for chapter in allChapter:
  p = Paragraph(chapter.get_text() + " " + chapter.a.get_text(), chapterStyle)
  Story.append(p)
  for section in allSectionToc:
    if (section.get_text().split(".")[0] == chapter.get_text().split()[0]):
      p = Paragraph(section.get_text(), sectionStyle)
      Story.append(p)

for chapter in allAppendixToc:
  p = Paragraph(chapter.get_text() + " " + chapter.a.get_text(), chapterStyle)
  Story.append(p)
  for section in allSectionToc:
    if (section.get_text().split(".")[0] == chapter.get_text().split()[0]):
      p = Paragraph(section.get_text(), sectionStyle)
      Story.append(p)
```

由于reportlab的创建pdf的构造器将创建第一页和第其他页区别开, 所以我们需要编写构造第一页和其他页的方法:

```py
# 在文件开头处加入pdf的页面大小
PAGE_HEIGHT=defaultPageSize[1]
PAGE_WIDTH=defaultPageSize[0]

# 其他代码...

# 第一页, 包含标题
def myFirstPage(canvas, doc):
  canvas.saveState()
  # 标题的样式
  canvas.setFont("Helvetica-Bold", 20)
  Title = 'Introduction to Computer Organization - Robert G. Plantz'
  canvas.drawCentredString(PAGE_WIDTH/2.0, PAGE_HEIGHT-108, Title)
  canvas.setFont('Times-Roman',9)
  canvas.drawString(inch, 0.75 * inch, "First Page")
  canvas.restoreState()

# 剩下的其他页
def myLaterPages(canvas, doc):
  canvas.saveState()
  canvas.setFont('Times-Roman',9)
  canvas.drawString(inch, 0.75 * inch, "Page %d" % (doc.page))
  canvas.restoreState()
```

这两个方法相差的仅仅是第一页需要绘制标题, 而其它页不需要。最后构造pdf文件:

```py
doc.build(Story, onFirstPage=myFirstPage, onLaterPages=myLaterPages)
```
