#!/bin/bash

pandoc main.tex \
  -s \
  -o main.html \
  --mathjax \
  --include-in-header=header.html \
  --css=style.css \
