#!/bin/bash

cat packages.txt | xargs -I {} R --slave -e "if('{}' %in% rownames(installed.packages()) == FALSE) {install.packages('{}')}"
