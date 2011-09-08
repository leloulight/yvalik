package Tk::Xlib;
require DynaLoader;

use vars qw($VERSION);
$VERSION = '4.004'; # $Id$

use Tk qw($XS_VERSION);
use Exporter;

use base  qw(DynaLoader Exporter);
@EXPORT_OK = qw(XDrawString XLoadFont XDrawRectangle);

bootstrap Tk::Xlib;

1;
