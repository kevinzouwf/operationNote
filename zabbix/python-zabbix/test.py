#!/usr/bin/python
# -*- coding: UTF-8 -*-
import yaml
import json
f = open('template.yml')
x = yaml.load(f)
x['id'] = 2
print x
b = json.dumps(x)
print b
