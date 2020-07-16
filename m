Return-Path: <kernel-hardening-return-19344-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id D9969222172
	for <lists+kernel-hardening@lfdr.de>; Thu, 16 Jul 2020 13:32:00 +0200 (CEST)
Received: (qmail 23664 invoked by uid 550); 16 Jul 2020 11:31:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 23629 invoked from network); 16 Jul 2020 11:31:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=kCBscy4ICmY9v1gZK6PYqPDzXfgn2dK6Smw6OZ6pwbU=; b=cRbax8BTeNpQ2tEZPMz++wHfoA
	YY9T8+65ROJBAdBZ7H8FzaY/KSeuSeoYlwNsCGmLP8mDevULQFXYgV781OyBKYpkpkWeq0Slxsu41
	EVIi5ybC98tuKjfgKsxKaDjZbeJDht1Recazoo7KeQuuxBxH+4aXVOmjx2RPn95gB5VEUNiMr4J3k
	MXflrKeV66Kc8r72b7/yQBgRCpSetCin1QZz9VjOlZsGG1eKVdFOyiJOEYD/MF3uEup1kOMDFOlI1
	j+MqVHQuoR5capmxrlF8mTZDWBljT+SXL6D8dERmtywfxxQfBTKjZFrNsVs4CnAkuWWd9HVhR0HuD
	wYPT/vcw==;
Date: Thu, 16 Jul 2020 12:29:14 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Kees Cook <keescook@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Allen Pais <allen.lkml@gmail.com>,
	Oscar Carter <oscar.carter@gmx.com>,
	Romain Perier <romain.perier@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Kevin Curtis <kevin.curtis@farsite.co.uk>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	Jiri Slaby <jslaby@suse.com>, Felipe Balbi <balbi@kernel.org>,
	Jason Wessel <jason.wessel@windriver.com>,
	Daniel Thompson <daniel.thompson@linaro.org>,
	Douglas Anderson <dianders@chromium.org>,
	Mitchell Blank Jr <mitch@sfgoth.com>,
	Julian Wiedmann <jwi@linux.ibm.com>,
	Karsten Graul <kgraul@linux.ibm.com>,
	Ursula Braun <ubraun@linux.ibm.com>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
	Christian Gromm <christian.gromm@microchip.com>,
	Nishka Dasgupta <nishkadg.linux@gmail.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Stephen Boyd <swboyd@chromium.org>,
	Wambui Karuga <wambui.karugax@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Chris Packham <chris.packham@alliedtelesis.co.nz>,
	Kyungtae Kim <kt0755@gmail.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Peter Zijlstra <peterz@infradead.org>,
	Will Deacon <will@kernel.org>, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	linux-s390@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-usb@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
	alsa-devel@alsa-project.org, kernel-hardening@lists.openwall.com
Subject: Re: [PATCH 2/3] treewide: Replace DECLARE_TASKLET() with
 DECLARE_TASKLET_OLD()
Message-ID: <20200716112914.GK12769@casper.infradead.org>
References: <20200716030847.1564131-1-keescook@chromium.org>
 <20200716030847.1564131-3-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200716030847.1564131-3-keescook@chromium.org>

On Wed, Jul 15, 2020 at 08:08:46PM -0700, Kees Cook wrote:
> This converts all the existing DECLARE_TASKLET() (and ...DISABLED)
> macros with DECLARE_TASKLET_OLD() in preparation for refactoring the
> tasklet callback type. All existing DECLARE_TASKLET() users had a "0"
> data argument, it has been removed here as well.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
[...]
>  16 files changed, 26 insertions(+), 21 deletions(-)

This is about 5% of what needs to change.  There are 350 callers of
tasklet_init(), and that still takes a 'data' argument.
