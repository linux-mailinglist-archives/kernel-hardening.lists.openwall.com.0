Return-Path: <kernel-hardening-return-16191-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id E1F764B4A3
	for <lists+kernel-hardening@lfdr.de>; Wed, 19 Jun 2019 11:06:28 +0200 (CEST)
Received: (qmail 1231 invoked by uid 550); 19 Jun 2019 09:06:22 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 1212 invoked from network); 19 Jun 2019 09:06:21 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u3kWunp1yg8qsBlz075d3zHcl3e5zCJuL+usdOTYmOc=;
        b=gnP9HHMGYKwK9IsnAHwypqrW+QHPyyxL5VsMOQFqOBt9sxJJN5Q28pik6LLPgli2C3
         8U4+LuFuA2pG4azWksKAC4dzSQH2hr74fm1ub0T1PmruwOzmCDKQaqlsvoLqIxDcuIwv
         c4hN54DM8GwFFMGvP3sPTRofnN8sE6FGqYkHE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u3kWunp1yg8qsBlz075d3zHcl3e5zCJuL+usdOTYmOc=;
        b=SnvXzQKPurtcm4N1AciTodiIBRf8zKMjC+0RZgRz+H8UEuw0FuJV/xPG+/bSYb6EPw
         S6IiROAyOsx9y+m7onYROyB/RBvSGxWMEGcgFAFWMZxKSJFGhg0IGT2g1MBFAjERuvd4
         xbf/rKueMCnUc0mhTAFRhxvscDnFGvkr3wABWMQR+q8R1eXIm55/I8eZuVg6dX3JZNiI
         sbqlBn3XLLCK1l/t0sQ51LHlJfTzUW+21L59GNneQTCptdaZ6+EbqgbF73aHXqZnmTbi
         mSdCIsPQn/sA3qqPwsHiXQURn3RsmqCaYkM9MAnPLy8DjRz+c+tnfAkI4tfTWKBBg02q
         72+w==
X-Gm-Message-State: APjAAAUIA5lyg6wvF+Nksx8mP4x4i1X8V507Kjs5QL1uJXzBC0++CRY9
	fmiJy6gqSBFOfz8rUGaZuAr2kn5lfCEo/Xi2yA1jKg==
X-Google-Smtp-Source: APXvYqzG/v8GSMVQIarAoClCL4IFuEHrrKyRFYYJXnbvihoMS3DzXDAwuocRw/1b+9yFPJR2Hoa9o9P/lmOprXYAeyI=
X-Received: by 2002:a9d:4b95:: with SMTP id k21mr21462009otf.281.1560935169757;
 Wed, 19 Jun 2019 02:06:09 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1560890771.git.mchehab+samsung@kernel.org> <b0d24e805d5368719cc64e8104d64ee9b5b89dd0.1560890772.git.mchehab+samsung@kernel.org>
In-Reply-To: <b0d24e805d5368719cc64e8104d64ee9b5b89dd0.1560890772.git.mchehab+samsung@kernel.org>
From: Daniel Vetter <daniel@ffwll.ch>
Date: Wed, 19 Jun 2019 11:05:57 +0200
Message-ID: <CAKMK7uGM1aZz9yg1kYM8w2gw_cS6Eaynmar-uVurXjK5t6WouQ@mail.gmail.com>
Subject: Re: [PATCH v1 12/22] docs: driver-api: add .rst files from the main dir
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Linux Doc Mailing List <linux-doc@vger.kernel.org>, 
	Mauro Carvalho Chehab <mchehab@infradead.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Johannes Berg <johannes@sipsolutions.net>, Kurt Schwemmer <kurt.schwemmer@microsemi.com>, 
	Logan Gunthorpe <logang@deltatee.com>, Bjorn Helgaas <bhelgaas@google.com>, 
	Alan Stern <stern@rowland.harvard.edu>, 
	Andrea Parri <andrea.parri@amarulasolutions.com>, Will Deacon <will.deacon@arm.com>, 
	Peter Zijlstra <peterz@infradead.org>, Boqun Feng <boqun.feng@gmail.com>, 
	Nicholas Piggin <npiggin@gmail.com>, David Howells <dhowells@redhat.com>, 
	Jade Alglave <j.alglave@ucl.ac.uk>, Luc Maranget <luc.maranget@inria.fr>, 
	"Paul E. McKenney" <paulmck@linux.ibm.com>, Akira Yokosawa <akiyks@gmail.com>, 
	Daniel Lustig <dlustig@nvidia.com>, Stuart Hayes <stuart.w.hayes@gmail.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Darren Hart <dvhart@infradead.org>, Kees Cook <keescook@chromium.org>, 
	Emese Revfy <re.emese@gmail.com>, Ohad Ben-Cohen <ohad@wizery.com>, 
	Bjorn Andersson <bjorn.andersson@linaro.org>, Corey Minyard <minyard@acm.org>, 
	Marc Zyngier <marc.zyngier@arm.com>, William Breathitt Gray <vilhelm.gray@gmail.com>, 
	Jaroslav Kysela <perex@perex.cz>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>, 
	Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>, "David S. Miller" <davem@davemloft.net>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Johannes Thumshirn <morbidrsa@gmail.com>, 
	Steffen Klassert <steffen.klassert@secunet.com>, Sudip Mukherjee <sudipm.mukherjee@gmail.com>, 
	=?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>, 
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, Rodolfo Giometti <giometti@enneenne.com>, 
	Richard Cochran <richardcochran@gmail.com>, Thierry Reding <thierry.reding@gmail.com>, 
	Sumit Semwal <sumit.semwal@linaro.org>, Gustavo Padovan <gustavo@padovan.org>, 
	Jens Wiklander <jens.wiklander@linaro.org>, Kirti Wankhede <kwankhede@nvidia.com>, 
	Alex Williamson <alex.williamson@redhat.com>, Cornelia Huck <cohuck@redhat.com>, 
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, David Airlie <airlied@linux.ie>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <maxime.ripard@bootlin.com>, Sean Paul <sean@poorly.run>, 
	Farhan Ali <alifm@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>, 
	Halil Pasic <pasic@linux.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Christian Borntraeger <borntraeger@de.ibm.com>, 
	Harry Wei <harryxiyou@gmail.com>, Alex Shi <alex.shi@linux.alibaba.com>, 
	Evgeniy Polyakov <zbr@ioremap.net>, Jerry Hoemann <jerry.hoemann@hpe.com>, 
	Wim Van Sebroeck <wim@linux-watchdog.org>, Guenter Roeck <linux@roeck-us.net>, 
	Guan Xuetao <gxt@pku.edu.cn>, Arnd Bergmann <arnd@arndb.de>, Linus Walleij <linus.walleij@linaro.org>, 
	Bartosz Golaszewski <bgolaszewski@baylibre.com>, Andy Shevchenko <andy@infradead.org>, 
	Jiri Slaby <jslaby@suse.com>, linux-wireless@vger.kernel.org, 
	Linux PCI <linux-pci@vger.kernel.org>, 
	"open list:GENERIC INCLUDE/A..." <linux-arch@vger.kernel.org>, platform-driver-x86@vger.kernel.org, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-remoteproc@vger.kernel.org, 
	openipmi-developer@lists.sourceforge.net, linux-crypto@vger.kernel.org, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, netdev <netdev@vger.kernel.org>, 
	linux-pwm <linux-pwm@vger.kernel.org>, dri-devel <dri-devel@lists.freedesktop.org>, 
	kvm@vger.kernel.org, 
	Linux Fbdev development list <linux-fbdev@vger.kernel.org>, linux-s390@vger.kernel.org, 
	linux-watchdog@vger.kernel.org, 
	"moderated list:DMA BUFFER SHARING FRAMEWORK" <linaro-mm-sig@lists.linaro.org>, linux-gpio <linux-gpio@vger.kernel.org>, 
	Linux MM <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, Jun 18, 2019 at 10:55 PM Mauro Carvalho Chehab
<mchehab+samsung@kernel.org> wrote:
> diff --git a/Documentation/gpu/drm-mm.rst b/Documentation/gpu/drm-mm.rst
> index fa30dfcfc3c8..b0f948d8733b 100644
> --- a/Documentation/gpu/drm-mm.rst
> +++ b/Documentation/gpu/drm-mm.rst
> @@ -320,7 +320,7 @@ struct :c:type:`struct file_operations <file_operations>` get_unmapped_area
>  field with a pointer on :c:func:`drm_gem_cma_get_unmapped_area`.
>
>  More detailed information about get_unmapped_area can be found in
> -Documentation/nommu-mmap.rst
> +Documentation/driver-api/nommu-mmap.rst

Random drive-by comment: Could we convert these into hyperlinks within
sphinx somehow, without making them less useful as raw file references
(with vim I can just type 'gf' and it works, emacs probably the same).
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
