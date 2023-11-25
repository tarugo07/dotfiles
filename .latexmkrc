#!/usr/bin/env perl
$pdf_mode         = 3;
# $latex            = 'uplatex -halt-on-error';
# $latex_silent     = 'uplatex -halt-on-error -interaction=batchmode';
# $bibtex           = 'upbibtex';
$latex            = 'platex -halt-on-error';
$latex_silent     = 'platex -halt-on-error -interaction=batchmode';
$bibtex           = 'pbibtex';
$dvipdf           = 'dvipdfmx %O -o %D %S';
$makeindex        = 'mendex %O -o %D %S';
