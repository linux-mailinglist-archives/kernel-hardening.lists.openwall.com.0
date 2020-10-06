Return-Path: <kernel-hardening-return-20108-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id C3EE628440F
	for <lists+kernel-hardening@lfdr.de>; Tue,  6 Oct 2020 04:28:36 +0200 (CEST)
Received: (qmail 17810 invoked by uid 550); 6 Oct 2020 02:28:31 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 17772 invoked from network); 6 Oct 2020 02:28:30 -0000
Date: Tue, 6 Oct 2020 04:28:09 +0200
From: Willy Tarreau <w@1wt.eu>
To: Kees Cook <keescook@chromium.org>
Cc: Thibaut Sautereau <thibaut.sautereau@clip-os.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org,
        Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Emese Revfy <re.emese@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] random32: Restore __latent_entropy attribute on
 net_rand_state
Message-ID: <20201006022808.GA5531@1wt.eu>
References: <20201002151610.24258-1-thibaut.sautereau@clip-os.org>
 <202010051910.BC7E9F4@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202010051910.BC7E9F4@keescook>
User-Agent: Mutt/1.6.1 (2016-04-27)

Hi Kees,

On Mon, Oct 05, 2020 at 07:12:29PM -0700, Kees Cook wrote:
> On Fri, Oct 02, 2020 at 05:16:11PM +0200, Thibaut Sautereau wrote:
> > From: Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>
> > 
> > Commit f227e3ec3b5c ("random32: update the net random state on interrupt
> > and activity") broke compilation and was temporarily fixed by Linus in
> > 83bdc7275e62 ("random32: remove net_rand_state from the latent entropy
> > gcc plugin") by entirely moving net_rand_state out of the things handled
> > by the latent_entropy GCC plugin.
> > 
> > From what I understand when reading the plugin code, using the
> > __latent_entropy attribute on a declaration was the wrong part and
> > simply keeping the __latent_entropy attribute on the variable definition
> > was the correct fix.
> > 
> > Fixes: 83bdc7275e62 ("random32: remove net_rand_state from the latent entropy gcc plugin")
> > Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > Cc: Willy Tarreau <w@1wt.eu>
> > Cc: Emese Revfy <re.emese@gmail.com>
> > Signed-off-by: Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>
> 
> Yes, that looks correct. Thank you!
> 
> Acked-by: Kees Cook <keescook@chromium.org>
> 
> I'm not sure the best tree for this. Ted, Andrew, Linus? I'll take it
> via my gcc plugin tree if no one else takes it. :)

It was already merged as commit 09a6b0bc3be79 and queued for -stable.

Cheers,
Willy
