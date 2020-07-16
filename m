Return-Path: <kernel-hardening-return-19363-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id E9E2C222C0D
	for <lists+kernel-hardening@lfdr.de>; Thu, 16 Jul 2020 21:41:58 +0200 (CEST)
Received: (qmail 17417 invoked by uid 550); 16 Jul 2020 19:41:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 16360 invoked from network); 16 Jul 2020 19:41:52 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3gOxjYioleYNPMJFOYuFriXJ1YWGB4fcC91h6vBo3AM=;
        b=Fr2pMUFudxKVbymBQqlGxui5jPhioRVxbJPrydkQ5elV1iKym/58d4sNFYGtty3uRp
         ppQt1KX9e/iTFclG5XD8YE50MucJPCYqheHk4WCaco8MBAvjPQqzFnbKFDy8R/MWo2Hy
         sg4MwHJ75FbB5KhjWajQt52DC+O4j6U0z5B7s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3gOxjYioleYNPMJFOYuFriXJ1YWGB4fcC91h6vBo3AM=;
        b=fBO4mfDyJ7YDw0WP+QQloq9WEdxJq35iSntK8Z9TrT8oc7Rw1cl/ULQGN72+TbQ/qp
         zlaAcuvY5EIi9gmAUugfgbqY6QjGpmAi7FNE2SXTEyzSaajkNIaOkbYK9/GRx09LegAZ
         hpu58mxWU3vQ/plMOnG5f6coiYuj3HfpNRI8geDl8Z6IXTmUPofL8LejU/UBb476dP2x
         bhWDLNUnQ5iUUdBRd/8L/QZI3qcPJUOTZz6fjAlpY5GIAKQGNXhUmkMJLaufw1cUajgS
         gLVre6ygiCaE6H0RRveyiqY7o/UpLynWdEoekm2Gjm3sBb7A0zIunDZ2HxH+25S6mJ16
         AgGg==
X-Gm-Message-State: AOAM532xl6/iJwIUdoaL5wkbxYa/vJXYYIroUvmfuQcbbfny7BpQs+pP
	faL5xB1XPlj9b43q4OCatuUICw==
X-Google-Smtp-Source: ABdhPJxOpv1P54xTLFHMOCkbV36YgtJta4Xy1e3mGKWxQZVIYwZy7MSHr7Sn/WN5zPxdQ5Dy/Lrr9w==
X-Received: by 2002:a17:902:b60e:: with SMTP id b14mr4854255pls.81.1594928500423;
        Thu, 16 Jul 2020 12:41:40 -0700 (PDT)
Date: Thu, 16 Jul 2020 12:41:38 -0700
From: Kees Cook <keescook@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Oscar Carter <oscar.carter@gmx.com>,
	Mitchell Blank Jr <mitch@sfgoth.com>,
	kernel-hardening@lists.openwall.com,
	Peter Zijlstra <peterz@infradead.org>,
	kgdb-bugreport@lists.sourceforge.net,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	alsa-devel@alsa-project.org, Allen Pais <allen.lkml@gmail.com>,
	Christian Gromm <christian.gromm@microchip.com>,
	Will Deacon <will@kernel.org>, devel@driverdev.osuosl.org,
	Jonathan Corbet <corbet@lwn.net>,
	Daniel Thompson <daniel.thompson@linaro.org>,
	"David S. Miller" <davem@davemloft.net>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Takashi Iwai <tiwai@suse.com>, Julian Wiedmann <jwi@linux.ibm.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	Nishka Dasgupta <nishkadg.linux@gmail.com>,
	Jiri Slaby <jslaby@suse.com>, Jakub Kicinski <kuba@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Wambui Karuga <wambui.karugax@gmail.com>,
	Vasily Gorbik <gor@linux.ibm.com>, linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
	linux-input@vger.kernel.org, Ursula Braun <ubraun@linux.ibm.com>,
	Stephen Boyd <swboyd@chromium.org>,
	Chris Packham <chris.packham@alliedtelesis.co.nz>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jaroslav Kysela <perex@perex.cz>, Felipe Balbi <balbi@kernel.org>,
	Kyungtae Kim <kt0755@gmail.com>, netdev@vger.kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Douglas Anderson <dianders@chromium.org>,
	Kevin Curtis <kevin.curtis@farsite.co.uk>,
	linux-usb@vger.kernel.org,
	Jason Wessel <jason.wessel@windriver.com>,
	Romain Perier <romain.perier@gmail.com>,
	Karsten Graul <kgraul@linux.ibm.com>
Subject: Re: [PATCH 1/3] usb: gadget: udc: Avoid tasklet passing a global
Message-ID: <202007161240.B58F7FE@keescook>
References: <20200716030847.1564131-1-keescook@chromium.org>
 <20200716030847.1564131-2-keescook@chromium.org>
 <20200716072823.GA971895@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200716072823.GA971895@kroah.com>

On Thu, Jul 16, 2020 at 09:28:23AM +0200, Greg Kroah-Hartman wrote:
> On Wed, Jul 15, 2020 at 08:08:45PM -0700, Kees Cook wrote:
> > There's no reason for the tasklet callback to set an argument since it
> > always uses a global. Instead, use the global directly, in preparation
> > for converting the tasklet subsystem to modern callback conventions.
> > 
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > ---
> >  drivers/usb/gadget/udc/snps_udc_core.c | 6 ++----
> >  1 file changed, 2 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/usb/gadget/udc/snps_udc_core.c b/drivers/usb/gadget/udc/snps_udc_core.c
> > index 3fcded31405a..afdd28f332ce 100644
> > --- a/drivers/usb/gadget/udc/snps_udc_core.c
> > +++ b/drivers/usb/gadget/udc/snps_udc_core.c
> > @@ -96,9 +96,7 @@ static int stop_pollstall_timer;
> >  static DECLARE_COMPLETION(on_pollstall_exit);
> >  
> >  /* tasklet for usb disconnect */
> > -static DECLARE_TASKLET(disconnect_tasklet, udc_tasklet_disconnect,
> > -		(unsigned long) &udc);
> > -
> > +static DECLARE_TASKLET(disconnect_tasklet, udc_tasklet_disconnect, 0);
> >  
> >  /* endpoint names used for print */
> >  static const char ep0_string[] = "ep0in";
> > @@ -1661,7 +1659,7 @@ static void usb_disconnect(struct udc *dev)
> >  /* Tasklet for disconnect to be outside of interrupt context */
> >  static void udc_tasklet_disconnect(unsigned long par)
> >  {
> > -	struct udc *dev = (struct udc *)(*((struct udc **) par));
> > +	struct udc *dev = udc;
> >  	u32 tmp;
> >  
> >  	DBG(dev, "Tasklet disconnect\n");
> 
> Feel free to just take this in your tree, no need to wait for the USB
> stuff to land.
> 
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Okay, thanks! I'll carry this series for v5.9, unless I hear otherwise
from Thomas. :)

-- 
Kees Cook
