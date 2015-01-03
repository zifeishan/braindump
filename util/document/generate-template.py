#! /usr/bin/env python
# -*- coding: utf-8 -*-


import sys

colors = ['yellow', 'cyan', 'magenta', 'orange', 'lime', 'greenyellow', 'lightblue', 'Chartreuse', 'DarkKhaki', 'DeepPink']

def getColor(index):
  return colors[index % (len(colors))]

variables = sys.argv[1:]

spanArray = []
tagArray = []
span2 = ''

# Generate templates for each variable
for i, var in enumerate(variables):
  span = '''
          <span mindtagger-highlight-words index-arrays="tag.%s" with-style="background-color:%s;"></span>''' % (var, getColor(i))

  spanArray.append(span)

  tag = "%s: { type: 'set' }" % var
  tagArray.append(tag)

  if span2 == '':
    span2 = '''
        <span mindtagger-value-set-tag="'%s'" with-value="item.selection"
            render-each-value="item.words | filterArrayByIndexes:value:'postgres'"></span>''' % var



print '''<mindtagger mode="recall">

  <template for="each-item">
      <big mindtagger-word-array="item.words" array-format="postgres">
          %s
          <span mindtagger-highlight-words index-array="item.selection" with-style="border-bottom: 2px solid;"></span>
          <span mindtagger-selectable-words index-array="item.selection"></span>
          <span mindtagger-highlight-words index-array="item.positions" array-format="postgres" with-style="text-decoration: underline;"></span>
      </big>
  </template>

  <template for="tags">
      <span>In Document: {{item.doc_id}}</span>
      <div ng-init="
        MindtaggerTask.defineTags(
        { 
          %s
        })
        "> 
        %s
            
    </div>
  </template>

</mindtagger>
''' % (
  ''.join(spanArray), 
  ', '.join(tagArray),
  span2
  )
