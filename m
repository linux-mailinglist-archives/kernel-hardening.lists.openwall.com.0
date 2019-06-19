Return-Path: <kernel-hardening-return-16198-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 9AD104B929
	for <lists+kernel-hardening@lfdr.de>; Wed, 19 Jun 2019 14:54:56 +0200 (CEST)
Received: (qmail 28118 invoked by uid 550); 19 Jun 2019 12:54:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 23904 invoked from network); 19 Jun 2019 12:50:54 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Xtb4b1kSnmdV6z5RW+KhyWhbk8J0VV+tx8yXGWcbZHU=;
        b=dW6rwWu/BxDcyY37Sf4zZHhk/BxlkdwN5gN343V7zBSAZ0SXuKFyO6NPG58mQ5ktr7
         PN+pIt0Tf0P/O3MDbO5prUrx8y576kfXAtnvM1ptZXz6JvVYc9biiGzrxZO4uaaDBgpE
         KAE0I5m0k/ivEF/VdemPUpTQTc+0vGOjxKUGU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Xtb4b1kSnmdV6z5RW+KhyWhbk8J0VV+tx8yXGWcbZHU=;
        b=L3r9gxLsZCkQD7FzfObCYCaRusP0AfAbJM4AtuM+B1/ZobMGLtd2WYN4cIg/qD4GW3
         +m6nQK77U27MkbR/0jmLuNxbJSaiYSGDFV5MPUB+iOtpZya6MBz6ZFAZJ4Etm6eog04l
         XiUdWFZRbrhwbfT8ztKs8NR+1DjkfkLyo3kgllVl83qVI78iH0FIvqf5B8ULgjYnXehy
         BKhX+TFJtCPHzcc2pIl+ZDYeZLQDiaHDCEUf5tVgkRT5CM9FO/lJsP9yBE6hSiWpP3qS
         JKC5Av12P1mLm0nOdCNrxfCWNj1WXZX7z9UpFsa4h8CWjsBsXEo+87gzwo9fl7R7AvSQ
         3rDg==
X-Gm-Message-State: APjAAAWejdgvG6X8eJ1Lg7LsILOYL4Tusy9OixFrtiHFifJPdD4cldrF
	uXd0zJgnmjuYAj4+j3xK4cL3uA==
X-Google-Smtp-Source: APXvYqwrwhHdCyqZaSphz++F46CL3btA19KM3IT0OW+E8P4zQsLmtEh4sw1cdFoR2IThHvbCs9vwSA==
X-Received: by 2002:a5d:40ca:: with SMTP id b10mr26804056wrq.171.1560948642938;
        Wed, 19 Jun 2019 05:50:42 -0700 (PDT)
Date: Wed, 19 Jun 2019 14:50:34 +0200
From: Andrea Parri <andrea.parri@amarulasolutions.com>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	Kurt Schwemmer <kurt.schwemmer@microsemi.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Will Deacon <will.deacon@arm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	David Howells <dhowells@redhat.com>,
	Jade Alglave <j.alglave@ucl.ac.uk>,
	Luc Maranget <luc.maranget@inria.fr>,
	"Paul E. McKenney" <paulmck@linux.ibm.com>,
	Akira Yokosawa <akiyks@gmail.com>,
	Daniel Lustig <dlustig@nvidia.com>,
	Stuart Hayes <stuart.w.hayes@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Darren Hart <dvhart@infradead.org>,
	Kees Cook <keescook@chromium.org>, Emese Revfy <re.emese@gmail.com>,
	Ohad Ben-Cohen <ohad@wizery.com>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Corey Minyard <minyard@acm.org>,
	Marc Zyngier <marc.zyngier@arm.com>,
	William Breathitt Gray <vilhelm.gray@gmail.com>,
	Jaroslav Kysela <perex@perex.cz>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	"Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
	Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Johannes Thumshirn <morbidrsa@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
	Andreas =?iso-8859-1?Q?F=E4rber?= <afaerber@suse.de>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Rodolfo Giometti <giometti@enneenne.com>,
	Richard Cochran <richardcochran@gmail.com>,
	Thierry Reding <thierry.reding@gmail.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Gustavo Padovan <gustavo@padovan.org>,
	Jens Wiklander <jens.wiklander@linaro.org>,
	Kirti Wankhede <kwankhede@nvidia.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Cornelia Huck <cohuck@redhat.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <maxime.ripard@bootlin.com>,
	Sean Paul <sean@poorly.run>, Farhan Ali <alifm@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Heiko Carstens <heiko.carstens@de.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	Harry Wei <harryxiyou@gmail.com>,
	Alex Shi <alex.shi@linux.alibaba.com>,
	Evgeniy Polyakov <zbr@ioremap.net>,
	Jerry Hoemann <jerry.hoemann@hpe.com>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Guenter Roeck <linux@roeck-us.net>, Guan Xuetao <gxt@pku.edu.cn>,
	Arnd Bergmann <arnd@arndb.de>,
	Linus Walleij <linus.walleij@linaro.org>,
	Bartosz Golaszewski <bgolaszewski@baylibre.com>,
	Andy Shevchenko <andy@infradead.org>, Jiri Slaby <jslaby@suse.com>,
	linux-wireless@vger.kernel.org, linux-pci@vger.kernel.org,
	linux-arch@vger.kernel.org, platform-driver-x86@vger.kernel.org,
	kernel-hardening@lists.openwall.com,
	linux-remoteproc@vger.kernel.org,
	openipmi-developer@lists.sourceforge.net,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	netdev@vger.kernel.org, linux-pwm@vger.kernel.org,
	dri-devel@lists.freedesktop.org, kvm@vger.kernel.org,
	linux-fbdev@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-watchdog@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	linux-gpio@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v1 12/22] docs: driver-api: add .rst files from the main
 dir
Message-ID: <20190619125034.GA8909@andrea>
References: <cover.1560890771.git.mchehab+samsung@kernel.org>
 <b0d24e805d5368719cc64e8104d64ee9b5b89dd0.1560890772.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b0d24e805d5368719cc64e8104d64ee9b5b89dd0.1560890772.git.mchehab+samsung@kernel.org>
User-Agent: Mutt/1.5.24 (2015-08-30)

>  rename Documentation/{ => driver-api}/atomic_bitops.rst (99%)

Same here: NAK, this document does not belong to driver-api.

I also realize that, despite previous notices, you keep touching
documentation without even CC-ing the people who care...

  Andrea
